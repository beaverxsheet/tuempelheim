extends CanvasLayer

var item_in_crosshairs = null
var inventory_shown = false
var show_chest_inventory = false


func _ready():
	$MainHUD/PanelContainer.hide()
	$Chest.hide()
	var globals = get_node("/root/globals")
	

func _process(delta):
	# Hide or show depending on visibility of inventory
	if inventory_shown:
		$MainHUD.hide()
	else:
		$MainHUD.show()
	
	if show_chest_inventory:
		$Chest.show()
	else:
		$Chest.hide()
		
	# Hide or show the item infobox
	if item_in_crosshairs:
		$MainHUD/PanelContainer.update_panel_info(item_in_crosshairs)
		$MainHUD/PanelContainer.show()
	else:
		$MainHUD/PanelContainer.hide()


func _on_close_ChestInventory_pressed():
	show_chest_inventory = false

func create_itemlist_control_node(name, amount, align_right, is_player):
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
	newButton.text = "Transfer"
	
	# Add signal, connect to self upon being pressed
	newButton.connect("pressed", self, "_on_button_transfer_press", [is_player, String(name)])
	
	if align_right:
		# Reorder things to mirror and align to the right
		newAmnt.align = Label.ALIGN_RIGHT
		newLabel.align = Label.ALIGN_RIGHT
		newContainer.add_child(newButton)
		newContainer.add_child(newAmnt)
		newContainer.add_child(newLabel)
	
	else: 
		newContainer.add_child(newLabel)
		newContainer.add_child(newAmnt)
		newContainer.add_child(newButton)
		
	return newContainer

func loop_to_create_itemlist(object, dict, align_right=false, is_player=false):
	# Delete all pre-existing children
	for c in object.get_children():
		c.queue_free()
	# Populate with new children
	var new
	for i in dict:
		print(i)
		new = create_itemlist_control_node(dict[i][0], dict[i][1], align_right, is_player)
		object.add_child(new)

func fill_chest_and_personal_itemlists(dict):
	# Use chest inventory and display
	var c_inventory = {}
	for i in dict:
		c_inventory[i] = [globals.itemArray[i].item_name, dict[i]] # {ITEM_ID: [ITEM_NAME, AMT]}
	loop_to_create_itemlist($Chest/ChestInventory/VBoxContainer/ScrollContainer/ScrollableItems, c_inventory)
	
	# Fill Player inventory with player inventory
	# Same as above, but using playerinventory dict stored globally
	# But the keys are item_name and not the objects themselves
	var p_inventory = {}
	for i in globals.inventoryContents:
		p_inventory[i] = [i.item_name, globals.inventoryContents.get(i)] # {ITEM_ID: [ITEM_NAME, AMT]}
	loop_to_create_itemlist($Chest/YourInventory/VBoxContainer/ScrollContainer/ScrollableItems, p_inventory, true, true) # TODO: Replace dict with actual player inventory
	show_chest_inventory = true
	
func _on_button_transfer_press(is_player, name):
	if is_player:
		print("owned by player")
	else:
		print("not owned by you")
	print(name)
