extends Node

func _ready() -> void:
	var cfg : Config = load("res://iniformat/config.cfg")
	print(cfg.dns)
	cfg.dns = "override"
	
	var cfg2 = load("res://iniformat/config.cfg")
	print(cfg2.dns)
