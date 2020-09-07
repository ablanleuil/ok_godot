tool
extends Resource
class_name Config

const structure = {
	"api" : [
		["dns", "127.0.0.1", {}],
		["port", 8080, {}],
		["scheme", "http", {}],
		["ws_scheme", "ws", {}],
	],
	"audio" : [
		["volume", 1.0, {"hint":PROPERTY_HINT_RANGE, "hint_string":"0.0,1.0"}]
	]
}

var dns : String
var port : int
var scheme : String
var ws_scheme : String

var volume : float setget set_volume

func set_volume(v):
	print("volume set, need to do something with audio streams")
	volume = v

func _get_property_list():
	var list = []
	for section in structure.keys():
		list.push_back({ "name":section, "type":0, "usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_GROUP })
		for variable in structure[section]:
			match variable:
				[var v, var d, var h]:
					var base = { "name" : v, "type" : typeof(d), "usage" : PROPERTY_USAGE_DEFAULT }
					for k in h.keys():
						base[k] = h[k]
					list.push_back(base)
	return list
