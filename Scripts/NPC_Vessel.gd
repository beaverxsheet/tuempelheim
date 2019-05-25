extends "res://Scripts/Sprite3D_controls.gd"

onready var animplayer_child = get_parent().get_node("Viewport/TestTyp/AnimationPlayer")

func _process(delta):
#	print(get_Sprite_angle())
#	print(get_Distance(get_Player()))
	if get_Distance(get_Player()) < 30:
		animplayer_child.play("Dance")
	else:
		animplayer_child.play("Wave")
