extends Area2D

var player = null

signal found_player
signal lost_player

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	emit_signal("found_player")

func _on_PlayerDetectionZone_body_exited(body):
	player = null
	emit_signal("lost_player")
