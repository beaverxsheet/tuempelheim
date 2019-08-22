extends Spatial

onready var globals = get_node("/root/globals")
var savname

class_name Domain

func _ready():
	# Update inventories of all containers, expand to all states of all winteractors
	load_state()


func load_state():
	var save_game = File.new()
	savname = get_savename()
	print(savname)
	# Check if filename exists
	if not save_game.file_exists(savname):
		print("does not exist")
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
	var kids = get_children()
	var wInteractors = []
	for node in kids:
		if node.is_class("WorldInteractor"):
			wInteractors.append(node)
	return wInteractors
	
func get_savename():
	return globals.saveLocation + get_fname_identifier(self) + ".sav"
	

# OVERRIDE so the type can be referred
func get_class(): return "Domain"
func is_class(type): return type == "Domain" or .is_class(type)