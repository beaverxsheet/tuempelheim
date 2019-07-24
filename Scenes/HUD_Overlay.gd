extends Control

var item_in_crosshairs = null

func _ready():
	$PanelContainer.hide()
	

func _process(delta):
#	if item_in_crosshairs:
#		$PanelContainer.show()
#	else:
#		$PanelContainer.hide()
	print(item_in_crosshairs)