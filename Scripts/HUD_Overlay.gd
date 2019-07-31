extends CanvasLayer

var item_in_crosshairs = null
var inventory_shown = false
var show_chest_inventory = false

var chest_inventory_to_show = {}


func _ready():
	$MainHUD/PanelContainer.hide()
	$Chest.hide()
	

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
	
func create_itemlist_control_node(name):
	# Create a single item slot in the inventory list (eg in the chest stuff)
	var new
	new = Button.new()
	new.text = String(name)
	return new
	
func loop_to_create_itemlist(object, dict):
	# Delete all pre-existing children
	for c in object.get_children():
		c.queue_free()
	# Populate with new children
	var new
	for i in dict:
		print(i)
		new = create_itemlist_control_node(i)
		object.add_child(new)
	

