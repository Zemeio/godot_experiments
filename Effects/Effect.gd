extends AnimatedSprite


func _ready():
	frame = 0
	connect("animation_finished", self, "queue_free")

func animate():
	play("Animate")

func on(object: Node2D):
	object.get_parent().add_child(self)
	global_position = object.global_position
	animate()
