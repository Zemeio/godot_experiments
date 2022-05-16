extends Node2D

const GrassEffect := preload("res://Effects/GrassEffect.tscn")

func destroy():
	GrassEffect.instance().on(self)
	queue_free()

func _on_Hurtbox_area_entered(area):
	destroy()
