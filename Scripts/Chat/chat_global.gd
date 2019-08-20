# CHAT
extends Node

class lineData:
	extends Object
	
	var uniqueID
	var speakerID
	var content
	var linkTos
	var commands
	var endNow
	
	func _init(uniqueID, speakerID, content, linkTos, commands):
		uniqueID = uniqueID
		speakerID = speakerID
		content = content
		linkTos = linkTos
		commands = commands
		
		endNow = false
		
	func giveContent(printIt=false):
		var optionNum = len(content)
		if printIt:
			print(content[randint(optionNum)])
		return String(content[randint(optionNum)])
		
	func randint(upper):
	# Helper
	# Return random integer [0, upper]
		randomize()
		return randi() % int(upper)
		
func readSheet(filename):
	# Read and return contents of a chat file NOT PARSED
	var file = File.new()
	file.open(filename, File.READ)
	var content = file.get_as_text()
	file.close()
	return content
	
func parseSheet(content):
	print(content)

