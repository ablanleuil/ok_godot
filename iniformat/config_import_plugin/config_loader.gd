tool
extends ResourceFormatLoader
class_name ConfigLoader

func get_dependencies(_path:String, _types:String) -> void:
	pass

func get_recognized_extensions() -> PoolStringArray:
	return PoolStringArray(["cfg"])

func get_resource_type(_path:String) -> String:
	return "Config"

func handles_type(typename:String) -> bool:
	return typename == "Config"

func load(path:String, original_path:String):
	var file = ConfigFile.new()
	if file.load(original_path):
		return null

	var ret = Config.new()
	ret.take_over_path(path)
	for section in Config.structure.keys():
		for variable in Config.structure[section]:
			match variable:
				[var v, var d]:
					ret.set(v, file.get_value(section, v, d))

	return ret

func rename_dependencies(_path:String, _renames:String) -> int:
	return 0
