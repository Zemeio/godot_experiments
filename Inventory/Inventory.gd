extends Node

signal update_ui

var _items = []

func add_to_database(item) -> void:
	_items.push_back(item) # Your in-memory inventory could be this simple, though saving to json file would be more annoying
	emit_signal("update_ui") # Hook up to this from your GUI and come here and get the items out and remove all items from the GUI and re-add everything here
