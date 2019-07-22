extends "res://Scripts/Sprite3D_controls.gd"


onready var animplayer_child_front = get_parent().get_node("Viewport/TestTyp/AnimationPlayer")
onready var animplayer_child_back = get_parent().get_node("Viewport/Testtyp_Back/AnimationPlayer")
onready var player_node = get_Player()

var animplayer_child = null

func _process(delta):
	if get_Sprite_angle() == 0:
		get_parent().get_node("Viewport/TestTyp").hide()
		get_parent().get_node("Viewport/Testtyp_Back").show()
		animplayer_child = animplayer_child_back
	else:
		get_parent().get_node("Viewport/TestTyp").show()
		get_parent().get_node("Viewport/Testtyp_Back").hide()
		animplayer_child = animplayer_child_front
	


func _on_ChatArea_body_entered(body):
	if body == player_node:
		print('Hello there')


func _on_ChatArea_body_exited(body):
	if body == player_node:
		print('Till we meet again')


func _on_WideArea_body_entered(body):
	if body == player_node:
		animplayer_child.play("Dance")


func _on_WideArea_body_exited(body):
	if body == player_node:
		animplayer_child.play("Wave")
