extends KinematicBody

# Walk
var velocity = Vector3()
var direction = Vector3()
const MOVE_SPEED = 10
const RUN_SPEED = 30
const GRAV = -10
const ACCEL = 2
const DEACCEL = 6

#jumping
export (float) var jump_height = 5

const MOUSE_SENS = 0.3
const RAY_LEN = 1000

# Worldinteractor
enum {
	DOOR,
	BUTTON,
	CHEST,
	SHOP
}
export (float) var Interaction_Distance = 20

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
onready var convo_controller = preload("res://Scripts/Chat/convoController.gd")
onready var scene_changer = get_node("/root/Change_Scene")

enum {
	FREE_MOUSE,
	CAPTURE_MOUSE,
	OPEN_MENU,
	CLOSE_MENU
}

func _ready():
	# Connect to viewport_size_change
	get_tree().get_root().connect("size_changed", self, "viewport_size_changed")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_width_center = OS.get_window_size().x / 2
	camera_height_center = OS.get_window_size().y / 2
	
	convo_controller.parseSheet(convo_controller.readSheet("res://Testers/testchat"))

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
	if mouse_n_cam_bool_helper(FREE_MOUSE): # Uncapture mouse
		capture_mouse_mode(false)
	elif mouse_n_cam_bool_helper(CAPTURE_MOUSE): # Capture mouse
		capture_mouse_mode(true)
	elif mouse_n_cam_bool_helper(OPEN_MENU): # Show inventory
		get_parent().get_node("Control/Control").show()
		get_node("../Control").inventory_shown = true
		capture_mouse_mode(false)
	elif mouse_n_cam_bool_helper(CLOSE_MENU): # Hide inventory
		get_parent().get_node("Control/Control").hide()
		get_node("../Control").inventory_shown = false
		capture_mouse_mode(true)
	if Input.is_action_pressed("end"): # Quit
		get_tree().quit()
	if Input.is_action_just_pressed("ui_up") and not get_parent().get_node("Control/Control").visible: # Switch scene tester
		scene_changer.scene_change_and_fade("res://Scenes/World.tscn")
	fps.text = str(Engine.get_frames_per_second())


func _physics_process(delta):

	walk(delta)

	if cam_on:
		var mouse_pos = get_viewport().get_mouse_position()
		from = $Camera.project_ray_origin(mouse_pos)
		to = from + $Camera.project_ray_normal(mouse_pos) * RAY_LEN
		var space_state = get_world().direct_space_state
		var res = space_state.intersect_ray(from,to,[self])
		
		# Find ID of object that has been acted upon with mouseclick
		if find:
			# Pick shit up
			if res.has("position"):
				if get_Distance(res.collider) <= Interaction_Distance:
					if "type" in res.collider:
						print(res.collider.ID)
						globals.change_item_amount(1,res.collider.ID)
						res.collider.pickup()
					# Interact with WorldInteractors
					match res.collider.get_class():
						"WorldInteractor":
							res.collider.interact_onclick()
						"NPC":
							res.collider.interact_onclick()
			find = false
		
		# Show shit in crosshairs
		if res.has("position") and res.has("position"):
			if get_Distance(res.collider) <= Interaction_Distance:
				if "type" in res.collider:
					get_node("../Control").item_in_crosshairs = ["item", res.collider.ID]
				# Interact with WorldInteractors
				elif "is_world_interactor" in res.collider:
					match res.collider.interactor_type:
						DOOR:
							get_node("../Control").item_in_crosshairs = ["door", res.collider.door_describe_target]
				else:
					get_node("../Control").item_in_crosshairs = [null, null]
		else:
			get_node("../Control").item_in_crosshairs = [null, null]


func walk(delta):
# reset the direction of the player
	direction = Vector3()
	
	# get the rotation of the camera
	var aim = $Camera.get_global_transform().basis
	# check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	direction = direction.normalized()
	
	velocity.y += GRAV * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("move_sprint"):
		speed = RUN_SPEED
	else:
		speed = MOVE_SPEED
	
	# where would the player go at max speed
	var target = direction * speed
	
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# calculate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	# move
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height

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
			get_tree().paused = false
		elif !cam_on:
			cam_on = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
	elif !toggle:
		# Set mouse mode regardless of current state
		if set:
			cam_on = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
		elif !set:
			cam_on = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
	return cam_on

func mouse_n_cam_bool_helper(case):
	# Helper to clean up _process
	match case:
		FREE_MOUSE:
			if Input.is_action_just_pressed("exit") and cam_on and not get_parent().get_node("Control/Control").visible and not get_node("../Control").show_chest_inventory:
				return true
		CAPTURE_MOUSE:
			if Input.is_action_just_pressed("exit") and not cam_on and not get_parent().get_node("Control/Control").visible and not get_node("../Control").show_chest_inventory:
				return true
		OPEN_MENU:
			if Input.is_action_just_pressed("inventory") and not get_parent().get_node("Control/Control").visible and not get_node("../Control").show_chest_inventory:
				return true
		CLOSE_MENU:
			if Input.is_action_just_pressed("inventory") and get_parent().get_node("Control/Control").visible:
				return true
	return false

func get_Distance(target):
	# Gives distance from target
	return (global_transform.origin - target.global_transform.origin).length()