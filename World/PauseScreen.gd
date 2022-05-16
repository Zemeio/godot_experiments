extends Control

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		var paused = get_tree().paused
		get_tree().paused = not paused
		visible = not paused

func _on_Continue_pressed():
	get_tree().paused = false
	visible = false
