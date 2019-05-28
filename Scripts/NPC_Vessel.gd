extends "res://Scripts/Sprite3D_controls.gd"


onready var animplayer_child = get_parent().get_node("Viewport/TestTyp/AnimationPlayer")
onready var player_node = get_Player()

func _process(delta):
	if get_Sprite_angle() == 2:
		get_parent().get_node("Viewport/TestTyp").hide()
		get_parent().get_node("Viewport/Testtyp_Back").show()
	else:
		get_parent().get_node("Viewport/TestTyp").show()
		get_parent().get_node("Viewport/Testtyp_Back").hide()
	
	


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
