extends Node

static func getNumberOfActiveObjects(array):
	var objects = 0
	for o in array:
		if (is_instance_valid(o)):
			objects +=1
	return objects
