extends Object

onready var ld = preload("res://Scripts/Chat/lineData.gd")

var lineObjects = []

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
		info.pop_back()
		var currObj = ld.lineData(info[0], info[1], info[2], info[3], info[4])
		lineObjects.append(currObj)