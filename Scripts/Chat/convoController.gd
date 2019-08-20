extends Node

var ld = preload("res://Scripts/Chat/lineData.gd")
var lineObjects = []

func _init(source):
	parseSheet(readSheet(source))

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
		lineObjects.append(currObj)
		
#	for i in lineObjects: print(i.speakerID)
	
func destroy():
	self.queue_free()