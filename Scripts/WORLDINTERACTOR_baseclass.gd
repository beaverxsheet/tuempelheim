extends StaticBody

class_name WorldInteractor

enum {
	DOOR,
	BUTTON,
	CHEST
}

onready var globals = get_node("/root/globals")
onready var scene_changer = get_node("/root/Change_Scene")

export(int, "door", "button", "chest") var interactor_type = DOOR
export(String) var points_to = "res://Scenes/World.tscn"

var is_world_interactor = true

func interact_onclick():
	match interactor_type:
		DOOR:
			scene_changer.scene_change_and_fade(points_to)
		BUTTON:
			pass
		CHEST:
			pass