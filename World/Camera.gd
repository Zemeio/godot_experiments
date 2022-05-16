extends Camera2D

onready var top_left_boundary = $Boundaries/topLeft
onready var bottom_right_boundary = $Boundaries/BottomRight

func _ready():
	limit_top = top_left_boundary.position.y
	limit_left = top_left_boundary.position.x
	limit_bottom = bottom_right_boundary.position.y
	limit_right = bottom_right_boundary.position.x
