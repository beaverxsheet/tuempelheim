extends StaticBody

class_name WorldInteractor

onready var globals = get_node("/root/globals")
onready var scene_changer = get_node("/root/Change_Scene")

export(int, "door", "button", "chest") var interactor_type = 0
export(String) var points_to = "res://Scenes/World.tscn"

var is_world_interactor = true

func change_scene_onclick():
	scene_changer.scene_change_and_fade(points_to)