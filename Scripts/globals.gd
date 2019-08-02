extends Node

onready var b_class = load("res://Scripts/ITEMS_baseclass.gd")

var itemArray = []
var inventoryContents = {}

func add_item(item_ID, item_name, weight, value, item_type=0, is_unique=false):
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