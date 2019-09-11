extends Spatial

onready var globals = get_node("/root/globals")
onready var cam_on = true
var savname

class_name Domain

enum {
	FREE_MOUSE,
	CAPTURE_MOUSE,
	OPEN_MENU,
	CLOSE_INVENTORY,
	CLOSE_MENU,
	LEAVE_CHAT
}

func _ready():
	# Update inventories of all containers, expand to all states of all winteractors
	load_state()
	# Make all children except the control (UI) node to pause during pause
	for c in get_children():
		c.pause_mode = Node.PAUSE_MODE_STOP
	$Control.pause_mode = Node.PAUSE_MODE_PROCESS
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	handle_input()

func load_state():
	var save_game = File.new()
	savname = get_savename()
	# Check if filename exists
	if not save_game.file_exists(savname):
		return null
	
	# Get dictionary linking winteractor objects and their names
	var children = get_persisting_winteractors()
	var child_dict = {}
	for c in children:
		child_dict[c.name] = c
	
	save_game.open(savname, File.READ) # Read in file (we already know it exists)
	while not save_game.eof_reached():
		# Get current line and parse it
		var line = save_game.get_line()
		var p = JSON.parse(line)
		if typeof(p.result) == TYPE_DICTIONARY:
			# If parsing worked out, get the designated object
			var actOn = child_dict[p.result["name"]]
			# Reformat; initially the key is a string, needs to be int for both value and key
			var newInventory = {}
			for i in p.result["chest_inventory"].keys():
				newInventory[int(i)] = int(p.result["chest_inventory"][i])
			# Simply set the item amount
			actOn.set_item_amount(newInventory)
			actOn.money = int(p.result["money"])
		else:
			# Parsing didnt work out
			# This should only occur in the last line
	    	pass

func get_fname_identifier(object):
	var name = object.filename
	name = name.get_file()
	return name.replace(".tscn", "")
	
func get_persisting_winteractors():
	# Get persisting worldinteractors
	var kids = get_node("Navigation/NavigationMeshInstance").get_children()
	var wInteractors = []
	for node in kids:
		if node.is_class("WorldInteractor"):
			wInteractors.append(node)
	return wInteractors
	
func get_savename():
	return globals.saveLocation + get_fname_identifier(self) + ".sav"

func capture_mouse_mode(set=true, toggle=false):
	# Change mouse mode
	if toggle:
		# Toggle mouse mode
		if cam_on:
			cam_on = false
			$Player.cam_on = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
		elif !cam_on:
			cam_on = true
			$Player.cam_on = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
	elif !toggle:
		# Set mouse mode regardless of current state
		if set:
			cam_on = true
			$Player.cam_on = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
		elif !set:
			cam_on = false
			$Player.cam_on = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
	return cam_on

func mouse_n_cam_bool_helper(case):
	# Helper to clean up _process
	match case:
		FREE_MOUSE:
			if (Input.is_action_just_pressed("exit") and cam_on and not get_node("Control/Control").visible
			and not $Control.show_chest_inventory and not $Control.show_shop_inventory and not $Control/Chat.visible):
				return true
		CAPTURE_MOUSE:
			if (Input.is_action_just_pressed("exit") and not cam_on and not get_node("Control/Control").visible
			and not $Control.show_chest_inventory and not $Control.show_shop_inventory and not $Control/Chat.visible):
				return true
		OPEN_MENU:
			if (Input.is_action_just_pressed("inventory") and not get_node("Control/Control").visible
			 and not $Control.show_chest_inventory and not $Control.show_shop_inventory and not $Control/Chat.visible):
				return true
		CLOSE_INVENTORY:
			if Input.is_action_just_pressed("inventory") and get_node("Control/Control").visible:
				return true
		CLOSE_MENU:
			if Input.is_action_just_pressed("exit") and ($Control.show_chest_inventory or $Control.show_shop_inventory
			or $Control.inventory_shown):
				return true
		LEAVE_CHAT:
			if Input.is_action_just_pressed("exit") and $Control/Chat.visible:
				return true
	return false

func handle_input():
	# Formerly this function belonged to the player
	if mouse_n_cam_bool_helper(FREE_MOUSE): # Uncapture mouse
		capture_mouse_mode(false)
	elif mouse_n_cam_bool_helper(CAPTURE_MOUSE): # Capture mouse
		capture_mouse_mode(true)
	elif mouse_n_cam_bool_helper(OPEN_MENU): # Show inventory
		get_node("Control/Control").show()
		$Control.inventory_shown = true
		capture_mouse_mode(false)
	elif mouse_n_cam_bool_helper(CLOSE_INVENTORY): # Hide inventory
		get_node("Control/Control").hide()
		$Control.inventory_shown = false
		capture_mouse_mode(true)
	elif mouse_n_cam_bool_helper(CLOSE_MENU):
		$Control.show_chest_inventory = false
		$Control.show_shop_inventory = false
		get_node("Control/Control").hide()
		$Control.inventory_shown = false
		capture_mouse_mode(true)
	elif mouse_n_cam_bool_helper(LEAVE_CHAT):
		$Control/Chat/Exit.emit_signal("pressed")
	if Input.is_action_pressed("end"): # Quit
		get_tree().quit()
	if Input.is_action_just_pressed("ui_up") and not get_node("Control/Control").visible: # Switch scene tester
		$Player.scene_changer.scene_change_and_fade("res://Scenes/World.tscn")
	$Player.fps.text = str(Engine.get_frames_per_second())

# OVERRIDE so the type can be referred
func get_class(): return "Domain"
func is_class(type): return type == "Domain" or .is_class(type)