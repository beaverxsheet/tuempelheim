extends CanvasLayer

var item_in_crosshairs = null
var inventory_shown = false
var show_chest_inventory = false

var chest_inventory_to_show = {}


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

func create_itemlist_control_node(name, align_right):
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
	newAmnt.text = String(2)
	newAmnt.rect_min_size = Vector2(50, 0)
	newAmnt.add_font_override("font", load("res://Misc/Fonts/FONT_CURSIVE_24.tres"))
	
	
	newButton = Button.new()
	newButton.add_font_override("font", load("res://Misc/Fonts/FONT_STANDARD_24.tres"))
	newButton.text = "Transfer"
	
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

func loop_to_create_itemlist(object, dict, align_right=false):
	# Delete all pre-existing children
	for c in object.get_children():
		c.queue_free()
	# Populate with new children
	var new
	for i in dict:
		print(i)
		new = create_itemlist_control_node(i, align_right)
		object.add_child(new)

func fill_chest_and_personal_itemlists(dict):
	# Fill Chest inventory with res.collider.chest_inventory
	loop_to_create_itemlist($Chest/ChestInventory/VBoxContainer/ScrollContainer/ScrollableItems, dict)
	chest_inventory_to_show = dict
	# Fill Player inventory with player inventory
	var p_inventory = {}
	for i in globals.inventoryContents.keys():
		p_inventory[i.item_name] = globals.inventoryContents.get(i)
	loop_to_create_itemlist($Chest/YourInventory/VBoxContainer/ScrollContainer/ScrollableItems, p_inventory, true) # TODO: Replace dict with actual player inventory
	show_chest_inventory = true
	

