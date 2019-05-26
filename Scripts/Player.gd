extends KinematicBody

const MOVE_VEL = 10
const MOUSE_SENS = 0.3
const GRAV = 5

var cam_on = true

onready var fps = $CanvasLayer/Label

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion and cam_on:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		if not rotation_degrees.x >= 85 or not rotation_degrees.x <= -85:
			rotation_degrees.x -= MOUSE_SENS * event.relative.y
		if rotation_degrees.x >= 85: rotation_degrees.x = 85
		if rotation_degrees.x <= -85: rotation_degrees.x = -85
		#print(rotation_degrees.x)

func _process(delta):
	if Input.is_action_just_pressed("exit") and cam_on:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cam_on = false
	elif Input.is_action_just_pressed("exit") and not cam_on:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		cam_on = true
	if Input.is_action_pressed("end"):
		get_tree().quit()
	fps.text = str(Engine.get_frames_per_second())

func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forward"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backward"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0,1,0), rotation.y) * MOVE_VEL
	move_vec -= Vector3(0,GRAV,0)
	move_and_slide(move_vec)
	#move_and_collide(move_vec*delta)
	
	