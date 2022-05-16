extends HBoxContainer


const ItemUI = preload("res://Inventory/ItemUI.tscn")


func _ready():
	Inventory.connect("update_ui", self, "update_ui")

func update_ui():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for item in Inventory._items:
		var item_label: Button = ItemUI.instance()
		item_label.text = item.name
		add_child(item_label)
