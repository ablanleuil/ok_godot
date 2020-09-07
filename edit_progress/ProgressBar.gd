extends ProgressBar

export var control_step : float
export var display_string : String

var dragging = false

func _ready():
	self.percent_visible = false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			self.dragging = event.pressed
	
	if self.dragging:
		var posx = clamp(self.get_local_mouse_position().x / self.rect_size.x, 0.0, 1.0)
		if event.control:
			var half_step = self.control_step / 2.0
			var mod = fmod(posx, self.control_step)
			if mod >= half_step:
				posx = posx - mod + self.control_step
			else:
				posx = posx - mod
		self.value = self.min_value + (posx * (self.max_value - self.min_value))

func _draw():
	var string = display_string.format({
		"value":self.value,
		"max":self.max_value,
		"percent":(self.value / self.max_value) * 100.0
		})
	var font = self.get_font("")
	var ssize = font.get_string_size(string)
	self.draw_string(font, (self.rect_size - Vector2(ssize.x, 0.0)), string)
	
	var position = 0.0
	var height = self.rect_size.y
	var width = self.rect_size.x
	var half_step = (self.control_step / 2.0) * width
	while position < (1.0 - self.control_step / 2.0):
		var pos = position * width
		var half_pos = pos + half_step
		self.draw_line(Vector2(pos, 0), Vector2(pos, height), Color(1, 1, 1))
		#self.draw_line(Vector2(half_pos, height / 4.0), Vector2(half_pos, 3.0*height/4.0), Color(1, 1, 1))
		position += self.control_step
