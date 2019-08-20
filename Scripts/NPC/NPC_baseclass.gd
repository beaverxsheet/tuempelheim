extends KinematicBody

class_name NPC

export(int) var NPCID = 0

func _ready():
	pass


# OVERRIDE so the type can be referred
func get_class(): return "NPC"
func is_class(type): return type == "NPC" or .is_class(type)