extends Node

var ld = preload("res://Scripts/Chat/lineData.gd")
var lineObjects = []
var currentObject
var convoRunning
var NPC_statement = ""
var nextUps
var nextUps_text

func _init(source):
	# Load data
	parseSheet(readSheet(source))
	# Set important values now
	convoRunning = true
	
	# Switch to first lineobject
	switchCurrentObject(lineObjects[0])
	# Show first line
	NPC_statement = currentObject.giveContent()
	# Read first line nexts in
	nextUps = currentObject.giveReplyOptions()
	nextUps_text = currentObject.giveReplyOptions(false)
	

func readSheet(filename):
	# Read and return contents of a chat file NOT PARSED
	var file = File.new()
	file.open(filename, File.READ)
	var content = file.get_as_text()
	file.close()
	return String(content)

func parseSheet(content):
	# Return PARSED contents
	var byLine = Array(content.split("\n"))
	byLine.pop_back()
	
	for line in byLine:
		var info = Array(line.split("|"))
		
		# Reformat
		var _uniqueID = info[0].strip_edges()
		var _speakerID = info[1].strip_edges()
		var _content = info[2].strip_edges()
		_content = Array(_content.split("/"))
		var _linkTos = info[3].strip_edges()
		_linkTos = Array(_linkTos.split("/"))
		var _commands = info[4].strip_edges()
		_commands = Array(_commands.split("/"))
		
		var currObj = ld.new(_uniqueID, _speakerID, _content, _linkTos, _commands)
		add_child(currObj)
		lineObjects.append(currObj)

func continueConversation(nextUp):
	# Helper to move on to the next statement    
	# nextUps actually gives the line the player says
	# so we need to move on to the one that the player statement links to
	pass


func switchCurrentObject(new):
	# helper to switch the current object and execute all necessary code then
	currentObject = new
	currentObject.checkCommands()
	return 1

func destroy():
	self.queue_free()