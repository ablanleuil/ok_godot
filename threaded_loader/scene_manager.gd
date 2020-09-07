class_name SceneManager
extends Node

export var root_path : NodePath = ".."
export var loading_scene : PackedScene = null

var loading_thread = Thread.new()
var game_running = true

var resource_cache = {}
var pending_queue = []
var cache_mutex = Mutex.new()

var current_scene = null
onready var root_node = get_node(root_path)

func _ready() -> void:
	if not root_node:
		print_debug("Invalid root node path, cannot initialize SceneManager properly")
		return

	self.loading_thread.start(self, "_loading_func")
	print_debug("Scene Manager ready")

func _loading_func(_data) -> void:
	while game_running:
		cache_mutex.lock()
		for k in resource_cache.keys():
			if resource_cache[k] is ResourceInteractiveLoader:
				cache_mutex.unlock()
				var err = resource_cache[k].poll()
				cache_mutex.lock()
				if err == ERR_FILE_EOF:
					resource_cache[k] = resource_cache[k].get_resource()
				elif err != OK:
					resource_cache.erase(k)
		cache_mutex.unlock()
		OS.delay_msec(20)

func queue_load(res_path : String) -> bool:
	cache_mutex.lock()
	if res_path in resource_cache:
		return false

	resource_cache[res_path] = ResourceLoader.load_interactive(res_path)
	cache_mutex.unlock()
	return true

func wait_for(res_path : String) -> Resource:
	cache_mutex.lock()
	if not res_path in resource_cache:
		resource_cache[res_path] = ResourceLoader.load_interactive(res_path)
	cache_mutex.lock()
	
	while true:
		cache_mutex.lock()
		if resource_cache[res_path] is Resource:
			cache_mutex.unlock()
			return resource_cache[res_path]
		cache_mutex.unlock()
		OS.delay_msec(16)
	# this line is not reachable. simply here because of bad compiler analysis
	return null

func try_get(res_path : String) -> Resource:
	var ret = null
	cache_mutex.lock()
	if res_path in resource_cache and resource_cache[res_path] is Resource:
		ret = resource_cache[res_path]

	cache_mutex.unlock()
	
	return ret

func get_progress(res_path : String) -> Array:
	var ret = -1
	cache_mutex.lock()
	if not res_path in resource_cache:
		ret = -1
	elif resource_cache[res_path] is Resource:
		ret = 1.0
	else:
		ret = (float(resource_cache[res_path].get_stage()) / resource_cache[res_path].get_stage_count())
	cache_mutex.unlock()

	return ret

func change_scene(scene_path : String, scene_params : Dictionary) -> void:
	self.queue_load(scene_path)
	
	var already = self.try_get(scene_path)
	if already:
		self._change_scene(already, scene_params)
	else:
		var node = self._change_scene(loading_scene, { "loader" : self, "to_track" : scene_path })
		node.connect("loading_finished", self, "set_current_scene", [scene_params])

func _change_scene(scene : PackedScene, scene_params : Dictionary) -> Node:
	return set_current_scene(scene.instance(), scene_params)

func set_current_scene(node : Node, scene_params : Dictionary) -> Node:
	if current_scene:
		root_node.remove_child(current_scene)

	current_scene = node
	for k in scene_params.keys():

		# print("set_current_scene(): set %s = %s" % [k, scene_params[k]])

		node.set(k, scene_params[k])

	root_node.add_child(node)
	return node

func _exit_tree() -> void:
	self.game_running = false
	self.loading_thread.wait_to_finish()
	
	print_debug("Scene Manager terminated")
