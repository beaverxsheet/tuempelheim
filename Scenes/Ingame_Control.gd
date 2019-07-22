extends Control

onready var addTo_btn = $BackgroundPanel/VBoxContainer/HBoxContainer/Add_to
onready var lessN_btn = $BackgroundPanel/VBoxContainer/HBoxContainer/Remove_from

var pencil_amount = 99

func _ready():
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(pencil_amount)
	

func _process(delta):
	$BackgroundPanel/VBoxContainer/HBoxContainer/Amount.text = String(pencil_amount)

func _on_Add_to_pressed():
	pencil_amount += 1


func _on_Remove_from_pressed():
	pencil_amount -= 1
