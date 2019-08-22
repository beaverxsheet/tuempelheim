extends CanvasLayer

signal scene_changed()

onready var animation_player = $AnimationPlayer
onready var sheet = $Control/ColorRect

func scene_change_and_fade(path, origin, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout") # Set timer
	save_persisting_worldinteractors(origin)
	animation_player.play("fade") # Fade once timer has completed
	yield(animation_player, "animation_finished") # Wait for animation to finish
	get_tree().change_scene(path) # Change scene
	animation_player.play_backwards("fade") # Fade back out
	emit_signal("scene_changed")
	
	
func save_persisting_worldinteractors(origin):
	# Get persisting worldinteractors
	var kids = origin.get_children()
	var wInteractors = []
	for node in kids:
		if node.is_class("WorldInteractor"):
			wInteractors.append(node)
			
	# Save persists
	var save_game = File.new()
	save_game.open("res://Savetests/savegame.sav", File.WRITE)
	for i in wInteractors:
		var save_dict = {
			"name" : i.name,
			"chest_inventory" : i.chest_inventory,
			"money" : i.money
		}
		save_game.store_line(to_json(save_dict))
	save_game.close()

