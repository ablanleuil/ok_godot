extends Node2D

var loader
var to_track

signal loading_finished(node)

func _process(_delta : float) -> void:
	$Label.text = "%.2f" % [loader.get_progress(to_track)]
	var scene = loader.try_get(to_track)
	if scene:
		emit_signal("loading_finished", scene.instance())

func _exit_tree() -> void:
	print("loading screen exited")
