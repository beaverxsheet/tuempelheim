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