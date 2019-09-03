extends Node

onready var b_class = load("res://Scripts/ITEMS_baseclass.gd")

enum {
	MISC,
	WEAPON,
	CONSUMABLE,
	QUEST_ITEM,
	TOOL
}

const saveLocation = "res://Savetests/"

var itemArray = []
var goapArray = {}
var inventoryContents = {}
var player_money = 0

func _ready():
	add_item(0, "Pencil", 1, 1)
	add_item(1, "Cup", 1, 1)
	add_item(2, "Brötchen", 1, 1, CONSUMABLE)
	player_money = 10

func add_item(item_ID, item_name, weight, value, item_type=MISC, is_unique=false):
	var item = b_class.new()
	item.item_ID = item_ID
	item.item_name = item_name
	item.weight = weight
	item.value = value
	item.item_type = item_type
	item.is_unique = is_unique
	itemArray.append(item)

func change_item_amount(change, item_id):
	var item = globals.itemArray[item_id]
	var newValue
	if globals.inventoryContents.get(item, false):
		# Execute this if the item is already in inventory
		newValue = globals.inventoryContents[item] + change
	else:
		# Create new entry if not in inventory
		newValue = 0 + change
	if newValue > 0:
		globals.inventoryContents[item] = newValue
	else:
		globals.inventoryContents.erase(item)
		
func check_item_amount(item_id):
	var item = globals.itemArray[item_id]
	return globals.inventoryContents.get(item, 0)
	
func change_money_amount(change):
	player_money = player_money + change
	
func can_buy(ID, value=null):
	# Can item be bought
	if value == null:
		if (player_money - itemArray[ID].value) >= 0:
			return true
		elif (player_money - itemArray[ID].value) <= 0:
			return false
	else:
		if (player_money - value) >= 0:
			return true
		elif (player_money - value) <= 0:
			return false
			
static func dijkstra(graph, source):
	# Props to Wikipedia Pseudocode
	var Q = [] # Q is the set of all unvisited vertices
	
	for v in graph.vert_dict.values(): # Initialize Dijkstra, make sure defaults are set
		if v.id == source:
			v.distance = 0 # Source node dist = 0
		else:
			v.distance = 9e10 # = infinity (or just high number here)
		v.previous = null
		v.visited = false
		Q.append(v)
		
	Q.sort_custom(customSorter, "sort_dijkstra_distance") # Sort by ascending distance
	

	while Q:
		Q.sort_custom(customSorter, "sort_dijkstra_distance") # Sort by ascending distance
		
			
		var u = Q[0] # Select vertex with shortest distance, remove from unvisited, make current vertex
		Q.remove(0)
		
		for v in u.get_connections(): # For all connections of the current vertex
			if v in Q: # Make sure this vertex is unvisited yet
				var alt = u.distance + u.get_weight(v) # Calculate tentative new distance of neighbour
				if alt < v.distance: # If tentative new distance is < current dist, change current to match tentative
					v.distance = alt
					v.previous = u
			else:
				pass

func shortest_helper(v, path):
	# Work backwards recursively
	# From target node to root node
	if v.previous:
		path.append(v.previous.id)
		shortest_helper(v.previous, path)
		
func shortest(graph, v : String):
	# Find shortest path from root to target
	var target = graph.get_vertex(v) # Specify target
	var path = [target.id]
	shortest_helper(target, path) # Returns route from target to root
	path.invert() # Reverse to get root to target
	return path

class customSorter:
	# Align custom sorter scripts here
	# use with Array.sort_custom(customsorter, "func_name")
	static func sort_dijkstra_distance(a, b):
		# Sort Dijkstra Objects by distance
		if a.distance < b.distance:
			return true
		else:
			return false
	