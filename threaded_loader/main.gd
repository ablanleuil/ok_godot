extends Node

func _ready() -> void:
	$SceneManager.change_scene("res://threaded_loader/level1.tscn", { "scene_loader" : $SceneManager })
