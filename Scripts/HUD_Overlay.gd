extends CanvasLayer

var item_in_crosshairs = null
var inventory_shown = false

var show_chest_inventory = false
var chest_in_focus = null

var show_shop_inventory = false
var shop_in_focus = null


func _ready():
	$MainHUD/ItemDemonstrator.hide()
	$Chest.hide()
	$Shop.hide()
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
		
	if show_shop_inventory:
		$Shop.show()
	else:
		$Shop.hide()
		
	# Hide or show the item infobox
	match item_in_crosshairs[0]:
		"item":
			$MainHUD/ItemDemonstrator.update_panel_info(item_in_crosshairs[1])
			$MainHUD/ItemDemonstrator.show()
			$MainHUD/DoorDemonstrator.hide()
		"door":
			$MainHUD/DoorDemonstrator/VBoxContainer/Destination.text = item_in_crosshairs[1]
			$MainHUD/ItemDemonstrator.hide()
			$MainHUD/DoorDemonstrator.show()
		_:
			$MainHUD/ItemDemonstrator.hide()
			$MainHUD/DoorDemonstrator.hide()


func create_itemlist_control_node(name, amount, align_right, is_player, ID, is_shop, can_buy):
	# Create a single item slot in the inventory list (eg in the chest stuff)
	var newContainer
	var newLabel
	var newAmnt
	var newButton
	newContainer = HBoxContainer.new()
	
	newLabel = Label.new()
	if is_shop:
		newLabel.text = String(name) + ": " + String(globals.itemArray[ID].value) + "€"
	else:
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
	if is_shop:
		newButton.text = "Kaufen"
		if !globals.can_buy(ID):
			newButton.disabled = true
			newButton.hint_tooltip = "Du hast nicht genügend Geld"
		if is_player:
			newButton.text = "Verkaufen"
			if !can_buy:
				newButton.disabled = true
				newButton.hint_tooltip = "Dieser Laden käuft nichts"
	
	# Add signal, connect to self upon being pressed
	newButton.connect("pressed", self, "_on_button_transfer_press", [is_player, ID, String(name)])
	
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

func loop_to_create_itemlist(object, dict, align_right=false, is_player=false, is_shop=false, can_buy=false):
	# Delete all pre-existing children
	for c in object.get_children():
		c.queue_free()
	# Populate with new children
	var new
	for i in dict:
		new = create_itemlist_control_node(dict[i][0], dict[i][1], align_right, is_player, i, is_shop, can_buy)
		object.add_child(new)

func fill_chest_and_personal_itemlists(the_actual_object):
	# FOR CHEST
	chest_in_focus = the_actual_object
	# Use chest inventory and display
	var c_inventory = {}
	for i in chest_in_focus.chest_inventory:
		c_inventory[i] = [globals.itemArray[i].item_name, chest_in_focus.chest_inventory[i]] # {ITEM_ID: [ITEM_NAME, AMT]}
	loop_to_create_itemlist($Chest/ChestInventory/VBoxContainer/ScrollContainer/ScrollableItems, c_inventory)
	
	# Fill Player inventory with player inventory
	# Same as above, but using playerinventory dict stored globally
	# But the keys are item_name and not the objects themselves
	var p_inventory = {}
	for i in globals.inventoryContents:
		p_inventory[i.item_ID] = [i.item_name, globals.inventoryContents.get(i)] # {ITEM_ID: [ITEM_NAME, AMT]}
	loop_to_create_itemlist($Chest/YourInventory/VBoxContainer/ScrollContainer/ScrollableItems, p_inventory, true, true) # TODO: Replace dict with actual player inventory
	show_chest_inventory = true

func fill_shop_and_personal_itemlists(the_actual_object, can_buy=false):
	# FOR SHOPS
	shop_in_focus = the_actual_object
	# Use shop inventory and display
	var s_inventory = {}
	for i in shop_in_focus.chest_inventory:
		s_inventory[i] = [globals.itemArray[i].item_name, shop_in_focus.chest_inventory[i]] # {ITEM_ID: [ITEM_NAME, AMT]}
	loop_to_create_itemlist($Shop/ShopInventory/VBoxContainer/ScrollContainer/ScrollableItems, s_inventory, false, false, true)
	
	# Fill Player inventory with player inventory
	# Same as above, but using playerinventory dict stored globally
	# But the keys are item_name and not the objects themselves
	var p_inventory = {}
	for i in globals.inventoryContents:
		p_inventory[i.item_ID] = [i.item_name, globals.inventoryContents.get(i)] # {ITEM_ID: [ITEM_NAME, AMT]}
	loop_to_create_itemlist($Shop/YourInventory/VBoxContainer/ScrollContainer/ScrollableItems, p_inventory, true, true, true) # TODO: Replace dict with actual player inventory
	$Shop/YourInventory/VBoxContainer/MoneyContainer/MoneyValue.text = String(globals.player_money) + "€"
	show_shop_inventory = true

func _on_button_transfer_press(is_player, ID, name):
	if is_player:
		globals.change_item_amount(-1, ID)
		if chest_in_focus:
			chest_in_focus.change_item_amount(1, ID)
			fill_chest_and_personal_itemlists(chest_in_focus)
		elif shop_in_focus:
			shop_in_focus.change_item_amount(1,ID)
			fill_shop_and_personal_itemlists(shop_in_focus)
	else:
		globals.change_item_amount(1, ID)
		if chest_in_focus:
			chest_in_focus.change_item_amount(-1, ID)
			fill_chest_and_personal_itemlists(chest_in_focus)
		elif shop_in_focus:
			shop_in_focus.change_item_amount(-1,ID)
			globals.player_money -= globals.itemArray[ID].value
			fill_shop_and_personal_itemlists(shop_in_focus)

func _on_close_ShopInventory_pressed():
	# Close Shop UI
	show_shop_inventory = false

func _on_close_ChestInventory_pressed():
	# Close Chest UI
	show_chest_inventory = false
