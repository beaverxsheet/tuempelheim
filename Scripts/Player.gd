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
onready var scene_changer = get_node("/root/Change_Scene")

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
	else:
		find = false

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
					if "is_world_interactor" in res.collider or res.collider.is_class("NPC"):
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

func get_Distance(target):
	# Gives distance from target
	return (global_transform.origin - target.global_transform.origin).length()