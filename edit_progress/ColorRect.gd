extends ColorRect



func _on_PB1_value_changed(value):
	self.color.g = value


func _on_PB2_value_changed(value):
	self.color.r = value


func _on_PB3_value_changed(value):
	self.color.b = value
