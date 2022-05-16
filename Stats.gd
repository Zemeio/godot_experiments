extends Node

export (int) var max_health = 1 setget set_max_health
onready var health = max_health setget set_health

signal out_of_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	if health == value or value > max_health:
		return
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("out_of_health")

func set_max_health(value):
	max_health = value # Allow less than 1 so that we can kill ourselves
	if self.health:
		# Setting max_health after the game started
		self.health = min(self.health, max_health)
	emit_signal("max_health_changed", max_health)
