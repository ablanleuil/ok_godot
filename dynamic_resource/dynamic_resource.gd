extends Node

class MyRes:
	extends Resource
	
	export var x : int = 0

func _ready() -> void:
	var res = MyRes.new()
	res.take_over_path("res://mares.tres")
	
	print(load("res://mares.tres"))
	print(ResourceLoader.has("res://mares.tres"))
	print(ResourceLoader.has_cached("res://mares.tres"))

func _process(delta : float) -> void:
	print(ResourceLoader.has("res://mares.tres"))
	print(ResourceLoader.has_cached("res://mares.tres"))
