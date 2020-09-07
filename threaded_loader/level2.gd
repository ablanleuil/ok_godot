extends VBoxContainer

var scene_loader

func goto_level1() -> void:
	if not scene_loader or not scene_loader.has_method("change_scene"):
		print_debug("No scene_loader, or scene_loader has no change_scene method")
		return
	scene_loader.change_scene("res://threaded_loader/level1.tscn", { "scene_loader" : scene_loader })
