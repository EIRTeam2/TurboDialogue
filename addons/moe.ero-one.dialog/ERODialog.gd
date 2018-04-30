# Dialog tree resource
tool
extends Resource

export var connection_list = []

export var node_data = {}

func _ready():
	pass
	
func add_from_node(node):
	node_data[node.name] = {}
	node_data[node.name]["name"] = node.name
	node_data[node.name]["type"] = node.get_dialog_node_type()
	node_data[node.name]["offset"] = node.offset
	node_data[node.name]["data"] = node.to_dict()