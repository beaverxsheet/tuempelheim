extends KinematicBody

class_name NPC

export(int) var NPCID = 0

func _ready():
	pass

func interact_onclick():
	get_node("../Player").capture_mouse_mode(false)
	get_node("../Control/Chat").begin_chat("res://Testers/testchat")
	yield(get_node("../Control/Chat/Exit"), "pressed") # Resume operations once close button pressed
	get_node("../Player").capture_mouse_mode(true)


# OVERRIDE so the type can be referred
func get_class(): return "NPC"
func is_class(type): return type == "NPC" or .is_class(type)