tool
extends "EROTreeNode.gd"

func _init():
	allows_multinode = true

func to_dict():
	pass
func from_dict(dict):
	pass

func _ready():
	set_slot(0, true, TYPE_NIL, Color(1.0,1.0,1.0), true, TYPE_NIL, Color(1.0,1.0,1.0))
	add_child(Label.new())
	title = "Random"
	
static func get_dialog_node_type():
	return "Random Choice"

func execute_node(dialog, connections=null):
	randomize()
	var index = randi()%connections.size()
	print("RAND_INDEX: %d" % index)
	var connection = connections[index]
	dialog.execute_node(connection["to"])
