extends Node
# Props to Bogotobogo.com and their python implementation

var id; var adjacent; var distance; var visited; var previous;

func _init(node_name):
	id = node_name
	adjacent = {}
	distance = 9e10
	visited = false
	previous = null
	
func add_neighbour(neighbour, weight=0):
	# Add a node as neighbour
	adjacent[neighbour] = weight
	
func get_connections():
	# Returns all nodes that it has connections to
	return adjacent.keys()
	
func get_weight(neighbour):
	return adjacent[neighbour]
