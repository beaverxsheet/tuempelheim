extends StaticBody

class_name WorldInteractor

enum {
	DOOR,
	BUTTON,
	CHEST,
	SHOP
}


# General variables
var is_world_interactor = true
onready var globals = get_node("/root/globals")
onready var scene_changer = get_node("/root/Change_Scene")
export(int, "door", "button", "chest", "shop") var interactor_type = DOOR

# Door variables
export(String) var points_to = "res://Scenes/World.tscn"
export(String) var door_describe_target = ""

# Chest variables
export(Dictionary) var chest_inventory = {}

# Shop variables
export(int) var money = 0
export(bool) var can_shop_buy = false



func interact_onclick():
	match interactor_type:
		DOOR:
			scene_changer.scene_change_and_fade(points_to, get_tree().get_current_scene())
			return true
		BUTTON:
			pass
		CHEST:
			get_parent().capture_mouse_mode(false)
			get_node("../Control").fill_chest_and_personal_itemlists(self)
			yield(get_node("../Control/Chest/CenterBackPanel/Button"), "pressed") # Resume operations once close button pressed
			get_parent().capture_mouse_mode(true)
		SHOP:
			get_parent().capture_mouse_mode(false)
			get_node("../Control").fill_shop_and_personal_itemlists(self)
			yield(get_node("../Control/Shop/CenterBackPanel/Button"), "pressed") # Resume operations once close button pressed
			get_parent().capture_mouse_mode(true)
			
func change_item_amount(change, item_id):
	var item = globals.itemArray[item_id]
	var newValue
	if chest_inventory.get(item_id, false):
		# Execute this if the item is already in inventory
		newValue = chest_inventory[item_id] + change
	else:
		# Create new entry if not in inventory
		newValue = 0 + change
	if newValue > 0:
		chest_inventory[item_id] = newValue
	else:
		chest_inventory.erase(item_id)
		
func set_item_amount(info):
	chest_inventory = info
		
func check_item_amount(item_id):
	return chest_inventory.get(item_id, 0)
	
	
# OVERRIDE so the type can be referred
func get_class(): return "WorldInteractor"
func is_class(type): return type == "WorldInteractor" or .is_class(type)