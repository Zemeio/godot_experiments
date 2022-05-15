extends KinematicBody2D


export (int) var MOVE_SPEED = 90
export (int) var ACCELERATION = 700
export (int) var FRICTION = 700

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

var velocity := Vector2.ZERO

enum {
	MOVING,
	ATTACKING,
	ROLLING
}

var state = MOVING

func _ready():
	animation_tree.active = true

func _physics_process(delta):
#	match state:
#		MOVING:
#			move(delta)
#		ATTACKING:
#			attack(delta)
	match animation_state.get_current_node():
		"Idle":
			move(delta)
		"Run":
			move(delta)
		"Attack":
			attack(delta)


func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MOVE_SPEED, ACCELERATION * delta)
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Run/blend_position", velocity)
		animation_tree.set("parameters/Attack/blend_position", velocity)
		animation_state.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animation_state.travel("Idle")

	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACKING
		animation_state.travel("Attack")

func attack(delta):
	animation_state.travel("Attack")

func attack_finished():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION*4)
	state = MOVING
