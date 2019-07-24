extends Control

onready var addTo_btn = $BackgroundPanel/VBoxContainer/HBoxContainer/Add_to
onready var lessN_btn = $BackgroundPanel/VBoxContainer/HBoxContainer/Remove_from

var pencil_amount

# Array containing all objects
var itemArray = []

# Dictionary containing all collected items carried
var inventoryContents = {}

func _ready():
	itemArray.append(load("res://Scripts/ITEM_ID_0_Pencil.gd").new())
#	itemArray.append(load("res://Scripts/ITEM_ID_1_Cup.gd").new())
	pencil_amount = check_item_amount(0)
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(pencil_amount)

func _process(delta):
	pencil_amount = check_item_amount(0)
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(pencil_amount)


func change_item_amount(change, item_id, overrideNegative=false):
	var item = itemArray[item_id]
	if inventoryContents.get(item, false):
		var newValue = inventoryContents[item] + change
		if newValue < 0 and !overrideNegative:
			return "Cannot go below zero"
		elif newValue < 0 and overrideNegative:
			inventoryContents[item] = newValue
			return "Went below zero due to override"
		else:
			inventoryContents[item] = newValue
	else:
		var newValue = 0 + change
		if newValue < 0 and !overrideNegative:
			return "Cannot go below zero"
		elif newValue < 0 and overrideNegative:
			inventoryContents[item] = newValue
			return "Went below zero due to override"
		else:
			inventoryContents[item] = newValue
		
func check_item_amount(item_id):
	var item = itemArray[item_id]
	return inventoryContents.get(item, 0)


func _on_Add_to_pressed():
	# Add a pencil
	change_item_amount(1, 0)


func _on_Remove_from_pressed():
	# Remove a pencil
	change_item_amount(-1, 0)
