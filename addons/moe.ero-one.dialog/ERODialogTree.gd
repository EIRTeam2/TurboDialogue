extends Node

const ERODialog = preload("res://addons/moe.ero-one.dialog/ERODialog.gd")

export(Resource) var dialog = ERODialog.new()

const BASE_NODE = preload("res://addons/moe.ero-one.dialog/Nodes/InputNode.gd") # First node to be executed

const PLUGIN_CLASS = preload("res://addons/moe.ero-one.dialog/plugin.gd")

var nodes = {}

var current_node

# From ERO-ONE
#var dialog_renderer
func _ready():
	# From ERO-ONE
	#dialog_renderer = EROOverlayedMenus.dialog_renderer
	# Add all nodes to scene
	for node_name in dialog.node_data:
		var node_info = dialog.node_data[node_name]
		var node_data = node_info["data"]
		var node_class = PLUGIN_CLASS.get_dialog_node_of_type(node_info["type"])
		if node_class:
			var new_node = node_class.new()
			new_node.from_dict(node_data)
			new_node.hide() # Just to be sure
			add_child(new_node)
			
			nodes[node_info["name"]] = new_node
	
func execute_dialog():
	# From ERO-ONE
	#dialog_renderer.show()
	# find the input node
	for node_name in nodes:
		if nodes[node_name] is BASE_NODE:
			execute_node(node_name)

func execute_node(node_name):
	current_node = nodes[node_name]
	var connections = get_connected_nodes_for_node(node_name)
	current_node.execute_node(self, connections) 
	
func get_connected_nodes_for_node(node_name):
	var connections = []
	for connection in dialog.connection_list:
		if connection["from"] == node_name:
			connections.append(connection)
			
	return connections