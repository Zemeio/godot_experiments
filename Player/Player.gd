class_name Player
extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const PauseScreen = preload("res://World/PauseScreen.tscn")

export (int) var MOVE_SPEED = 90
export (int) var ACCELERATION = 700
export (int) var FRICTION = 700

export (int) var ROLL_SPEED = 120
export (int) var ROLL_ACCELERATION = 1100

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blink_animation_player = $BlinkAnimationPlayer

var velocity := Vector2.ZERO
var direction := Vector2.LEFT setget set_direction
var stats := PlayerStats


func set_direction(_direction: Vector2):
	direction = _direction
	if _direction == Vector2.ZERO:
		return
	
	if sword_hitbox:
		sword_hitbox.knockback_vector = _direction
	update_direction_for_all_animations()

func _ready():
	randomize()
	animation_tree.active = true
	stats.connect("out_of_health", self, "queue_free")
	set_direction(Vector2.LEFT)


func _physics_process(delta):

	match animation_state.get_current_node():
		"Idle":
			move(delta)
		"Run":
			move(delta)
		"Attack":
			attack(delta)
		"Roll":
			roll(delta)


func update_direction_for_all_animations():
	if direction == Vector2.ZERO:
		return
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Run/blend_position", direction)
	animation_tree.set("parameters/Attack/blend_position", direction)
	animation_tree.set("parameters/Roll/blend_position", direction)

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func move(delta):
	var input_vector := get_input_vector()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MOVE_SPEED, ACCELERATION * delta)
		animation_state.travel("Run")
		set_direction(input_vector) # Set direction when walking
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animation_state.travel("Idle")

	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("Attack"):
		animation_state.travel("Attack")
	elif Input.is_action_just_pressed("Roll"):
		animation_state.travel("Roll")

func attack(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func attack_finished():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION*4)

func roll(delta):
	velocity = velocity.move_toward(direction * ROLL_SPEED, ROLL_ACCELERATION)
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area: Hitbox):
	if not hurtbox.invincible:
		stats.health -= area.damage
		hurtbox.start_invincibility(0.6)
		hurtbox.create_hit_effect()
		get_parent().add_child(PlayerHurtSound.instance())


func _on_Hurtbox_invincibility_started():
	blink_animation_player.play("Start")


func _on_Hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")
