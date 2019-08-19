extends Control

onready var globals = get_node("/root/globals")
onready var itm = preload("res://Scenes/Items.tscn")


func _ready():
	globals.add_item(0, "Pencil", 1, 1)
	globals.add_item(1, "Cup", 1, 1)
	globals.add_item(2, "Brötchen", 1, 1, globals.CONSUMABLE)
	globals.player_money = 10


func _process(delta):
	pass

func drop():
	#drop item
	var ppos = get_node("../../Player/Position3D")
	var p_pos = ppos.global_transform.origin
	print(p_pos)
	var item = itm.instance()
	item.translation = p_pos
	get_tree().get_root().add_child(item)

func create_itemlist_control_node(name, amount, ID):
	# Create a single item slot in the inventory list (eg in the chest stuff)
	var newContainer
	var newLabel
	var newAmnt
	var newButton
	newContainer = HBoxContainer.new()
	
	newLabel = Label.new()
	newLabel.text = String(name)
	newLabel.rect_min_size = Vector2(150, 0)
	newLabel.add_font_override("font", load("res://Misc/Fonts/FONT_STANDARD_24.tres"))
	
	newAmnt = Label.new()
	newAmnt.text = String(amount)
	newAmnt.rect_min_size = Vector2(50, 0)
	newAmnt.add_font_override("font", load("res://Misc/Fonts/FONT_CURSIVE_24.tres"))
	
	
	newButton = Button.new()
	newButton.add_font_override("font", load("res://Misc/Fonts/FONT_STANDARD_24.tres"))
	newButton.text = "Fallen lassen"

	
	# Add signal, connect to self upon being pressed
	newButton.connect("pressed", self, "_on_button_transfer_press", [ID, String(name)])
	
	newContainer.add_child(newLabel)
	newContainer.add_child(newAmnt)
	newContainer.add_child(newButton)
		
	return newContainer

func fill_personal_itemlist():
	# Fill Player inventory with player inventory
	# Same as above, but using playerinventory dict stored globally
	# But the keys are item_name and not the objects themselves
	var dict = {}
	for i in globals.inventoryContents:
		dict[i.item_ID] = [i.item_name, globals.inventoryContents.get(i)] # {ITEM_ID: [ITEM_NAME, AMT]}
#		print(dict[i.item_ID])
		
	var listitems = $BackgroundPanel/VBoxContainer/Scroller/Listitems
	# Delete all pre-existing children
	for c in listitems.get_children():
		c.queue_free()
	# Populate with new children
	var new
	for i in dict:
		new = create_itemlist_control_node(dict[i][0], dict[i][1], i)  # ITEM_NAME, AMT
		listitems.add_child(new)


func _on_button_transfer_press(ID, name):
	globals.change_item_amount(-1, ID)
	fill_personal_itemlist()
	drop()

func _on_BackgroundPanel_visibility_changed():
	fill_personal_itemlist()
