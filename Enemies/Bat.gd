extends KinematicBody2D

const DeathEffect := preload("res://Effects/BatEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

onready var stats = $Stats
onready var body = $Body
onready var player_detection_zone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController
onready var blink_animation_player = $BlinkAnimationPlayer

export (int) var KNOCKBACK_SPEED := 120
export (int) var KNOCKBACK_FRICTION := 300
export (int) var MOVE_SPEED := 50
export (int) var MOVE_FRICTION := 200
export (int) var MOVE_ACCELERATION := 200
export (int) var BAT_REPULSION := 400  # Used to avoid overlapping with bats

var state := IDLE
var knockback := Vector2.ZERO
var velocity := Vector2.ZERO

func _ready():
	state = pick_random_state()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, MOVE_FRICTION * delta)
			if wander_controller.get_time_left() == 0:
				state = pick_random_state()
				wander_controller.start_wander_timer(rand_range(1, 3))
		WANDER:
			if wander_controller.get_time_left() == 0:
				state = pick_random_state()
				wander_controller.start_wander_timer(rand_range(1, 3))
			accelerate_towards_position(wander_controller.target_position, delta)

			var distance_to_target = global_position.distance_to(wander_controller.target_position)
			if distance_to_target < MOVE_SPEED * delta:
				state = pick_random_state()
		CHASE:
			var player = player_detection_zone.player as Player
			if player:
				accelerate_towards_position(player.global_position, delta)
			else:
				print("Enemy in chase mode, but no player in sight")

	velocity = avoid_overlapping_with_others(delta, velocity)
	velocity = move_and_slide(velocity)

func accelerate_towards_position(value: Vector2, delta):
	var direction = global_position.direction_to(value)
	velocity = velocity.move_toward(direction * MOVE_SPEED, MOVE_ACCELERATION * delta)
	body.flip_h = velocity.x < 0

func pick_random_state(states: Array=[IDLE, WANDER]):
	var states_copy = states.duplicate()
	states_copy.shuffle()
	return states_copy.pop_front()

func avoid_overlapping_with_others(delta, velocity_factor: Vector2):
	var repulsion_factor = soft_collision.get_push_vector() * delta * BAT_REPULSION
	return velocity_factor + repulsion_factor

func _on_Hurtbox_area_entered(area: Hitbox):
	stats.health -= area.damage
	knockback = area.knockback_vector*KNOCKBACK_SPEED
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_Stats_out_of_health():
	DeathEffect.instance().on(self)
	queue_free()

func _on_PlayerDetectionZone_found_player():
	state = CHASE

func _on_PlayerDetectionZone_lost_player():
	state = IDLE


func _on_Hurtbox_invincibility_started():
	blink_animation_player.play("Start")


func _on_Hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")
