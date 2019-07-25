extends CanvasLayer

var item_in_crosshairs = null
var inventory_shown = false


func _ready():
	$Control/PanelContainer.hide()
	

func _process(delta):
	if inventory_shown:
		$Control.hide()
	else:
		$Control.show()
	if item_in_crosshairs:
		$Control/PanelContainer.show()
	else:
		$Control/PanelContainer.hide()