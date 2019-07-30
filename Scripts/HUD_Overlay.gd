extends CanvasLayer

var item_in_crosshairs = null
var inventory_shown = false
var show_chest_inventory = false


func _ready():
	$Control/PanelContainer.hide()
	$ChestInventory.hide()
	

func _process(delta):
	# Hide or show depending on visibility of inventory
	if inventory_shown:
		$Control.hide()
	else:
		$Control.show()
	
	if show_chest_inventory:
		$ChestInventory.show()
	else:
		$ChestInventory.hide()
		
	# Hide or show the item infobox
	if item_in_crosshairs:
		$Control/PanelContainer.update_panel_info(item_in_crosshairs)
		$Control/PanelContainer.show()
	else:
		$Control/PanelContainer.hide()


func _on_close_ChestInventory_pressed():
	show_chest_inventory = false
