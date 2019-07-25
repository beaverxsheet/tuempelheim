extends KinematicBody

const MOVE_VEL = 10
const MOUSE_SENS = 0.3
const GRAV = 5
const RAY_LEN = 1000


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

var from = Vector3()
var to = Vector3()
var find = false

onready var globals = get_node("/root/globals")


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
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		find = true
		print("click")
	else:
		find = false


func _process(delta):
	if Input.is_action_just_pressed("exit") and cam_on and not get_parent().get_node("InventoryGUI").visible:
		capture_mouse_mode(false)
	elif Input.is_action_just_pressed("exit") and not cam_on and not get_parent().get_node("InventoryGUI").visible:
		capture_mouse_mode(true)
	elif Input.is_action_just_pressed("inventory") and not get_parent().get_node("InventoryGUI").visible:
		get_parent().get_node("InventoryGUI").show()
		capture_mouse_mode(false)
	elif Input.is_action_just_pressed("inventory") and get_parent().get_node("InventoryGUI").visible:
		get_parent().get_node("InventoryGUI").hide()
		capture_mouse_mode(true)
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
	var mouse_pos = get_viewport().get_mouse_position()
	from = $Camera.project_ray_origin(mouse_pos)
	to = from + $Camera.project_ray_normal(mouse_pos) * RAY_LEN
	var space_state = get_world().direct_space_state
	var res = space_state.intersect_ray(from,to,[self])
	if find:
		if res.has("position"):
			if("type" in res.collider):
				print(res.collider.ID)
				globals.change_item_amount(1,res.collider.ID)
				res.collider.pickup()
		find = false
	if res.has("position"):
		if("type" in res.collider):
			get_node("../Control").item_in_crosshairs = res.collider.ID
	else:
		get_node("../Control").item_in_crosshairs = null

func viewport_size_changed():
	# Update Viewport Width when Window gets resized
	camera_width_center = OS.get_window_size().x / 2
	camera_height_center = OS.get_window_size().y / 2
	
	
func capture_mouse_mode(set=true, toggle=false):
	# Change mouse mode
	if toggle:
		# Toggle mouse mode
		if cam_on:
			cam_on = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif !cam_on:
			cam_on = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif !toggle:
		# Set mouse mode regardless of current state
		if set:
			cam_on = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif !set:
			cam_on = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	return cam_on
