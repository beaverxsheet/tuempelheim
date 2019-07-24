extends Control

onready var addTo_btn = $BackgroundPanel/VBoxContainer/HBoxContainer/Add_to
onready var lessN_btn = $BackgroundPanel/VBoxContainer/HBoxContainer/Remove_from
onready var globals = get_node("/root/globals")

var pencil_amount

# Array containing all objects


# Dictionary containing all collected items carried

func _ready():
	globals.add_item(0, "Pencil", 1, 1)
	globals.add_item(1, "Cup", 1, 1)
	
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(globals.check_item_amount(0))
	$BackgroundPanel/VBoxContainer/HBoxContainer2/Amount.text = String(globals.check_item_amount(1))

func _process(delta):
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(globals.check_item_amount(0))
	$BackgroundPanel/VBoxContainer/HBoxContainer2/Amount.text = String(globals.check_item_amount(1))
	if Input.is_action_just_pressed("ui_down"):
		pass

func _pencil_add_to_pressed():
	# Add a pencil
	globals.change_item_amount(1, 0)

func _pencil_remove_from_pressed():
	# Remove a pencil
	globals.change_item_amount(-1, 0)


func _cup_add_to_pressed():
	globals.change_item_amount(1, 1)


func _cup_remove_from_pressed():
	globals.change_item_amount(-1, 1)
