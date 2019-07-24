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
	
	pencil_amount = globals.check_item_amount(0)
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(pencil_amount)

func _process(delta):
	pencil_amount = globals.check_item_amount(0)
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(pencil_amount)
	if Input.is_action_just_pressed("ui_down"):
		pass

func _on_Add_to_pressed():
	# Add a pencil
	globals.change_item_amount(1, 0)

func _on_Remove_from_pressed():
	# Remove a pencil
	globals.change_item_amount(-1, 0)
