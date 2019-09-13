extends Node
class_name Dijkstra_Vertex
# Props to Bogotobogo.com and their python implementation

var id; var adjacent; var distance; var visited; var previous; var execArray;

func _init(node_name):
	id = node_name
	adjacent = {}
	distance = 9e10
	visited = false
	previous = null
	
	execArray = [] # Stack of commands to execute in this vertex

func add_neighbour(neighbour, weight=0):
	# Add a node as neighbour
	adjacent[neighbour] = weight
	
func get_connections():
	# Returns all nodes that it has connections to
	return adjacent.keys()
	
func get_weight(neighbour):
	return adjacent[neighbour]

func add_execArray_step(_inarray):
	execArray.append(_inarray)
	execArray.sort_custom(customSorter, "sort_execArray_order")

class customSorter:
	# Align custom sorter scripts here
	# use with Array.sort_custom(customsorter, "func_name")
	static func sort_execArray_order(a, b):
		# Sort Dijkstra Vert ExecArray Commands by their order
		if a[2] < b[2]:
			return true
		else:
			return false