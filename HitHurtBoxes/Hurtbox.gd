extends Area2D

const HitEffect := preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer
onready var collision_shape = $CollisionShape2D

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	HitEffect.instance().on(self)


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring", false)
	collision_shape.disabled = true


func _on_Hurtbox_invincibility_ended():
	monitoring = true
	collision_shape.disabled = false
