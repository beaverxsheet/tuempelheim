extends Node
# Props to Bogotobogo.com and their python implementation

var vertex = preload("res://Scripts/NPC/Dijkstra_Vertex.gd")
onready var globals = get_node("/root/globals")
var vert_dict; var num_vertices; var _name;

func _init(givenname):
	vert_dict = {}
	num_vertices = 0
	_name = givenname
	
func add_vertex(node : String):
	num_vertices += 1
	var new_vertex = vertex.new(node)
	vert_dict[node] = new_vertex
	add_child(new_vertex)
	return new_vertex
	
func get_vertex(n : String):
	if n in vert_dict:
		return vert_dict[n]
	else:
		return null
		
func add_edge(frm : String, to : String, cost = 0):
	if !(frm in vert_dict):
		add_vertex(frm)
	if !(to in vert_dict):
		add_vertex(to)
	vert_dict[frm].add_neighbour(vert_dict[to], cost)
	vert_dict[to].add_neighbour(vert_dict[frm], cost)
	
func get_vertices():
	return vert_dict.keys()
	
func save():
	globals.goapArray[_name] = self

func diagnostics():
	# Check if graph is ok
	for v in vert_dict.values():
		for w in v.get_connections():
			print(v.id, "-", w.id)