extends PanelContainer

onready var globals = get_node("/root/globals")

func update_panel_info(id):
	var object = globals.itemArray[id]
	$VBoxContainer/HBoxContainer/VBoxContainer2/Statement.text = String(object.weight)
	$VBoxContainer/HBoxContainer/VBoxContainer3/Statement2.text = String(object.value)
