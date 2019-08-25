extends KinematicBody

class_name NPC

export(int) var NPCID = 0
export(int, "idle", "walk_idle", "seek") var interactor_type = WALK_IDLE

enum {
	IDLE,
	WALK_IDLE,
	SEEK
}

func _ready():
	print(translation)
	print(choose_random_nearby_target())

func interact_onclick():
	get_parent().capture_mouse_mode(false)
	get_node("../Control/Chat").begin_chat("res://Testers/testchat")
	yield(get_node("../Control/Chat/Exit"), "pressed") # Resume operations once close button pressed
	get_node("../Control/Chat").cancel_chat()
	get_parent().capture_mouse_mode(true)
	
func choose_random_nearby_target(max_range = 5, min_range = 3):
	# Function returns a location that the NPC can walk to in IDLE_WALK
	# Location is picked randomly between two bounds
	var floats = []; randomize()
	for i in range(2): floats.append(rand_range(-1, 1))
	var vec = Vector3(floats[0], floats[1], 0)
	vec = vec.normalized()
	return translation + vec * rand_range(min_range, max_range)
	
		
func choose_target_given_vector(target_delta):
	# Function returns a location that the NPC can walk to in IDLE_WALK
	if target_delta is Vector3:
		return translation + target_delta
	elif target_delta is Vector2:
		return translation + Vector3(target_delta.x, target_delta.y, 0)


# OVERRIDE so the type can be referred
func get_class(): return "NPC"
func is_class(type): return type == "NPC" or .is_class(type)