extends Sprite3D

onready var camera = get_tree().get_root().get_camera()

func get_Sprite_angle():
	# Sprite Angle gives direction from which player faces NPC/Object
	# 1 - Front
	# 0 - Back

	var dir = (global_transform.origin - camera.global_transform.origin).normalized()
	var angle = rad2deg(atan2(dir.z, dir.x)) + get_parent().rotation_degrees.y
	angle = wrapi(angle, 0, 360)

	var sprite_angle = int(floor(angle / 180) - 2)
	sprite_angle = wrapi(sprite_angle, 0, 2)

	return sprite_angle
	
func get_Player():
	# Gets Player
	return get_tree().get_root().get_node("/root/World/Player")
	
func get_Distance(target):
	# Gives distance from target
	return (global_transform.origin - target.global_transform.origin).length()
