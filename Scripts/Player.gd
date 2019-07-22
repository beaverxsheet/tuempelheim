extends KinematicBody

const MOVE_VEL = 10
const MOUSE_SENS = 0.3
const GRAV = 5

var cam_on = true

onready var fps = $CanvasLayer/Label

# RayCast for Interaction
var ability_range = 20
var camera_width_center = 0
var camera_height_center = 0
var shoot_origin = Vector3()
var shoot_to = Vector3()
var shooting = 0
var raycast_result = null


func _ready():
	# Connect to viewport_size_change
	get_tree().get_root().connect("size_changed", self, "viewport_size_changed")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_width_center = OS.get_window_size().x / 2
	camera_height_center = OS.get_window_size().y / 2

func _input(event):
	if event is InputEventMouseMotion and cam_on:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		if not rotation_degrees.x >= 85 or not rotation_degrees.x <= -85:
			rotation_degrees.x -= MOUSE_SENS * event.relative.y
		if rotation_degrees.x >= 85: rotation_degrees.x = 85
		if rotation_degrees.x <= -85: rotation_degrees.x = -85


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
	
	# Raycast
	shoot_origin = $Camera.project_ray_origin(Vector2(camera_width_center, camera_height_center))
	shoot_to = shoot_origin + $Camera.project_ray_normal(Vector2(camera_width_center, camera_height_center))*ability_range
	
	raycast_result = get_world().direct_space_state.intersect_ray(shoot_origin, shoot_to, [self])
	

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

func viewport_size_changed():
	# Update Viewport Width when Window gets resized
	camera_width_center = OS.get_window_size().x / 2
	camera_height_center = OS.get_window_size().y / 2