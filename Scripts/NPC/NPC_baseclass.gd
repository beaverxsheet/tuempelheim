extends KinematicBody

class_name NPC

onready var globals = get_node("/root/globals")
var vertex = preload("res://Scripts/NPC/Dijkstra_Vertex.gd")
var graph = preload("res://Scripts/NPC/Dijkstra_Graph.gd")

export(int) var NPCID = 0
export(int, "idle", "walk_idle", "seek") var interactor_type = WALK_IDLE

enum {
	IDLE,
	WALK_IDLE,
	SEEK
}

func _ready():
	# DIJKSTRA
	
	var g = parseSheetGOAP(readSheet("res://Testers/definition.goapml"))
	
#	var g = graph.new()
#	g.add_vertex('a')
#	g.add_vertex('b')
#	g.add_vertex('c')
#	g.add_vertex('d')
#	g.add_vertex('e')
#	g.add_vertex('f')
#
#	g.add_edge('a', 'b', 7)  
#	g.add_edge('a', 'c', 9)
#	g.add_edge('a', 'f', 14)
#	g.add_edge('b', 'c', 10)
#	g.add_edge('b', 'd', 15)
#	g.add_edge('c', 'd', 11)
#	g.add_edge('c', 'f', 2)
#	g.add_edge('d', 'e', 6)
#	g.add_edge('e', 'f', 9)
	
	# Check if graph is ok
	for v in g.vert_dict.values():
		for w in v.get_connections():
			print(v.id, "-", w.id)
	
	print(g._name)
#	globals.dijkstra(g, "a")
#	print(globals.shortest(g, "e"))

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

# OVERRIDE so the type can be referred
func get_class(): return "NPC"
func is_class(type): return type == "NPC" or .is_class(type)