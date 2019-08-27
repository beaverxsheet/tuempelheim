extends Node
# Props to Bogotobogo.com and their python implementation

var vertex = preload("res://Scripts/NPC/Dijkstra_Vertex.gd")
var vert_dict; var num_vertices;

func _init():
	vert_dict = {}
	num_vertices = 0
	
func add_vertex(node : String):
	num_vertices += 1
	var new_vertex = vertex.new(node)
	vert_dict[node] = new_vertex
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
		add_vertex(frm)
		
	vert_dict[frm].add_neighbour(vert_dict[to], cost)
	vert_dict[to].add_neighbour(vert_dict[frm], cost)
	
func get_vertices():
	return vert_dict.keys()
