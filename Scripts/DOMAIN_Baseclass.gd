extends Spatial

onready var globals = get_node("/root/globals")
var savname

class_name Domain

func _ready():
	load_state()

func load_state():
	var save_game = File.new()
	savname = get_savename()
	print(savname)
	if not save_game.file_exists(savname):
		print("does not exist")
		return null
	
	# Update all children
	var save_nodes = get_persisting_winteractors()
	
	save_game.open(savname, File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		print(current_line)

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