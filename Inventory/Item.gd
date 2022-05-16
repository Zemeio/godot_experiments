extends Area2D

enum DamageType { Fire, Ice, Wind, Water, Heart, Fart }

export (String) var Name
export (int) var Damage
export (float) var SpeedChange
export (int, "Fire", "Ice", "Wind", "Water", "Heart", "Fart") var TypeOfDamage


func _on_Item_body_entered(body: Node) -> void:
	add_to_database(Name, Damage, SpeedChange, TypeOfDamage)
	queue_free()

func add_to_database(name : String, damage : int, speed_change : float, damage_type) -> void:
	Inventory.add_to_database({ "name" : name, "damage" : damage, "speed_change" : speed_change, "damage_type" : damage_type })
	# Use this to manipulate your json file however you wish, or create an in-memory version and only save to the json file when exiting the app
