extends Control

onready var cc = preload("res://Scripts/Chat/convoController.gd")
onready var top = $CPanel/Overbox/Label
var active

func _ready():
	pass


func create_chat_control_node(text, ID):
	# Create a single clickable button that allows to select a chat option
	var newButton
	newButton = Button.new()
	newButton.add_font_override("font", load("res://Misc/Fonts/FONT_STANDARD_24.tres"))
	newButton.text = String(text)

	# Add signal, connect to self upon being pressed
	newButton.connect("pressed", self, "_on_chat_option_chosen", [ID])

	return newButton
	

func loop_to_fill_chat_options(inarray):
	# Show all chat reply options on sceen by repeatedly calling the function that creates the actual buttons
	var container = $CPanel/Overbox/Scroll/VBox
	for child in container.get_children():
		child.queue_free()
	var i = 0 # Counter to increment ID
	for text in inarray:
		# Create button for each option
		container.add_child(create_chat_control_node(text, i))
		i += 1
		
func _on_chat_option_chosen(ID):
	update_chat(ID)
	print(ID)
	
func begin_chat(source):
	show()
	active = cc.new(source)
	add_child(active)
	top.text = active.topStatement
	loop_to_fill_chat_options(active.nextUps_text)
	
func cancel_chat():
	hide()
	active.destroy()
	
func update_chat(ID):
	active.continueConversation(ID)
	if active.convoRunning:
		top.text = active.topStatement
		loop_to_fill_chat_options(active.nextUps_text)
	else:
		# End and close
		$Exit.emit_signal("pressed")