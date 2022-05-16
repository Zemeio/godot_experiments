extends Control


const HEART_NPIXELS = 15


var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull:
		heartUIFull.rect_size.x = hearts * HEART_NPIXELS
	
func set_max_hearts(value):
	max_hearts = max(value, 1) # UI will always show one heart, so that it is still visible
	if heartUIEmpty:
		heartUIEmpty.rect_size.x = max_hearts * HEART_NPIXELS
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
