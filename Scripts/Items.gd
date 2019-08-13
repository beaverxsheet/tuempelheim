extends RigidBody

var type = "Cup"
var ID = 1

func pickup():
	queue_free()
