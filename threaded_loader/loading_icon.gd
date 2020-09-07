extends Sprite

func _physics_process(delta):
	self.rotate((PI/8) * delta)
