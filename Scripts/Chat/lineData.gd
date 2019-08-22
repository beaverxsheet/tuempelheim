extends Node

var uniqueID
var speakerID
var content
var linkTos
var commands
var endNow

func _init(_uniqueID, _speakerID, _content, _linkTos, _commands):
	uniqueID  = _uniqueID
	speakerID = _speakerID
	content   = _content
	linkTos   = _linkTos
	commands  = _commands

	endNow = false

func giveContent(printIt=false):
	# Print or return the content of line. If options, randomly pick
	var optionNum = len(content)
	if printIt:
		print(content[randint(optionNum)])
	return String(content[randint(optionNum)])
	
	
func giveReplyOptions(object_form=true):
	# return all reply options, format as numbered replies
	var outputArray = []
	if object_form:
		
		for i in linkTos:
			outputArray.append(compareAndFinder(i, get_parent().lineObjects))
	else:
		var outputArrayOfText = []
		for i in linkTos:
			outputArray.append(compareAndFinder(i, get_parent().lineObjects).giveContent())
	return outputArray
		
func findBySpeakerID(given):
	# Returns if SpeakerID matches "given"
	if speakerID == given:
		return [true, self]
	else:
		return [false, 0]
		
func compareAndFinder(key, listObject, findWhat="speakerID"):
	# Iterates over listObject to return matching object
	match findWhat:
		"speakerID":
			for i in listObject:
				var b = i.findBySpeakerID(key)
				if b[0]:
					return b[1]
					
func checkCommands():
	# Check for commands. Currently functionality is limited
	# Only END func included
	if "END" in commands:
		endNow = true

func randint(upper):
	# Helper
	# Return random integer [0, upper]
	randomize()
	return randi() % int(upper)