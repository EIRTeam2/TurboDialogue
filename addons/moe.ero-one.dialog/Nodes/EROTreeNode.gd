tool
extends GraphNode

signal on_node_update # Called when the tree should be saved to resource

var allows_multinode = false # Allows connection to more than one node when set to true.

func _ready():
	connect("offset_changed", self, "emit_signal", ["on_node_update"]) # Save tree when the position of a node changes

func to_dict():
	pass

func from_dict(dict):
	pass

static func get_dialog_node_type():
	return "Tree Node"

func execute_node(dialog, connections=null):
	pass

# Build in helper function, simply executes the first connected node
func on_finish_execution(dialog, connections=null, args=[]):
	if connections:
		if connections[0]:
			dialog.execute_node(connections[0]["to"])


static func is_unique():
	return false
