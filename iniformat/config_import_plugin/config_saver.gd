tool
extends ResourceFormatSaver
class_name ConfigSaver

func get_recognized_extensions(resource : Resource) -> PoolStringArray:
	return PoolStringArray(["cfg"])

func recognize(resource : Resource) -> bool:
	return resource is Config

func save(path : String, resource : Resource, flags : int) -> int:
	var file := ConfigFile.new()
	file.load(path)
	if file.has_section("plugin"):
		return FAILED

	for section in Config.structure.keys():
		for variable in Config.structure[section]:
			match variable:
				[var v, var d]:
					var value = resource.get(v)
					if value != d:
						file.set_value(section, v, resource.get(v))
					else:
						file.erase_section_key(section, v)
					

	return file.save(path)
