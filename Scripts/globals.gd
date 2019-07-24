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

func change_item_amount(change, item_id, overrideNegative=false):
	var item = globals.itemArray[item_id]
	if globals.inventoryContents.get(item, false):
		var newValue = globals.inventoryContents[item] + change
		if newValue < 0 and !overrideNegative:
			return "Cannot go below zero"
		elif newValue < 0 and overrideNegative:
			globals.inventoryContents[item] = newValue
			return "Went below zero due to override"
		else:
			globals.inventoryContents[item] = newValue
	else:
		var newValue = 0 + change
		if newValue < 0 and !overrideNegative:
			return "Cannot go below zero"
		elif newValue < 0 and overrideNegative:
			globals.inventoryContents[item] = newValue
			return "Went below zero due to override"
		else:
			globals.inventoryContents[item] = newValue
		
func check_item_amount(item_id):
	var item = globals.itemArray[item_id]
	return globals.inventoryContents.get(item, 0)