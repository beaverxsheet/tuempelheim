extends KinematicBody

class_name NPC

var sprint_now = false
var path = []
var path_ind = 0
const MOVE_SPEED = 10
const RUN_SPEED = 30
const GRAV = -10

onready var globals = get_node("/root/globals")
onready var nav = get_parent().get_node("Navigation")
onready var player = get_parent().get_node("Player")
var vertex = preload("res://Scripts/NPC/Dijkstra_Vertex.gd")
var graph = preload("res://Scripts/NPC/Dijkstra_Graph.gd")

export(int) var NPCID = 0
export(int, "idle", "walk_idle", "seek") var interactor_type = WALK_IDLE

var gothisplace

enum {
	IDLE,
	WALK_IDLE,
	SEEK
}

func _ready():
#	var g = parseSheetGOAP(readSheet("res://Testers/definition.goapml"))
#
#	globals.dijkstra(g, "idle")
#	print(globals.shortest(g, "done"))
	
#	gothisplace = choose_target_given_vector(Vector3(100, 0, 0))
	path = nav.get_simple_path(translation, get_parent().get_node("Position3D").translation)

func _physics_process(delta):
	walk()
	

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

func readSheet(filename):
	# Read and return contents of a chat file NOT PARSED
	var file = File.new()
	file.open(filename, File.READ)
	var content = file.get_as_text()
	file.close()
	return String(content)

func parseSheetGOAP(content):
	# Parser for GOAP
	var g
	# Return PARSED contents
	var byLine = Array(content.split("\n"))
	byLine.pop_back()
	
	for line in byLine:
		if !line:
			# Ignore all empty lines
			continue
		
		if line[0] == "#":
			# Ignore all comments
			continue

		# Split and clean
		var info = Array(line.split("|"))
		for i in len(info):
			info[i] = info[i].strip_edges()

		match info[0]:
			"NEWG":
				if !g:
					# Only create new graph if this is the only graph instantiated
					g = graph.new(String(info[1]))
				else:
					pass
			"VERT":
				if g:
					g.add_vertex(String(info[1]))
			"EDGE":
				if g:
					g.add_edge(String(info[1]), String(info[2]), int(info[3]))
			_:
				pass
	return g

func walk():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - translation)
		move_vec.y = 0
		if move_vec.length() < 2:
			path_ind += 1
		else:
			move_and_slide(move_vec.normalized() * MOVE_SPEED, Vector3(0, 1, 0))
	else:
		look_at(Vector3(player.translation.x, translation.y, player.translation.z), Vector3(0, 1, 0))

# OVERRIDE so the type can be referred
func get_class(): return "NPC"
func is_class(type): return type == "NPC" or .is_class(type)