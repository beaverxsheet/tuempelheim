extends StaticBody

class_name WorldInteractor

enum {
	DOOR,
	BUTTON,
	CHEST,
	SHOP
}

onready var globals = get_node("/root/globals")
onready var scene_changer = get_node("/root/Change_Scene")

export(int, "door", "button", "chest", "shop") var interactor_type = DOOR

export(String) var points_to = "res://Scenes/World.tscn"
export(Dictionary) var chest_inventory = {}

var is_world_interactor = true

func interact_onclick():
	match interactor_type:
		DOOR:
			scene_changer.scene_change_and_fade(points_to)
			return true
		BUTTON:
			pass
		CHEST:
			pass
		SHOP:
			pass
			
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
		
func check_item_amount(item_id):
	return chest_inventory.get(item_id, 0)