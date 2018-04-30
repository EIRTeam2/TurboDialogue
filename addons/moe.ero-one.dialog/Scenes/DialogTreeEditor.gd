tool
extends Control

onready var graph_editor = get_node("VBoxContainer/HBoxContainer/GraphEdit")

const ERODialog = preload("res://addons/moe.ero-one.dialog/ERODialog.gd")

var editing_object

var contextual_menu

var plugin

func _ready():
	graph_editor.connect("connection_request", self, "connection_request")
	graph_editor.add_valid_connection_type(TYPE_NIL, TYPE_NIL)

	contextual_menu = PopupMenu.new()
	for type in plugin.DIALOG_NODE_SCRIPTS:
		contextual_menu.add_item(type.get_dialog_node_type())
	add_child(contextual_menu)
	graph_editor.connect("gui_input", self, "on_gui_input")
	graph_editor.connect("delete_nodes_request", self, "on_delete_nodes_request")
	contextual_menu.connect("index_pressed", self, "on_create_node")

func on_create_node(index):
	var new_node = create_node(contextual_menu.get_item_text(index))
	new_node.offset = graph_editor.scroll_offset + get_viewport().get_mouse_position()

func on_delete_nodes_request():
	for node in graph_editor.get_children():
		if node is GraphNode:
			if node.selected:
				for connection in graph_editor.get_connection_list():
					if node.name == connection["to"] or node.name == connection["from"]:
						graph_editor.disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
				node.free()
	save_to_resource()

func on_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_RIGHT:
			if ev.is_pressed() and not ev.is_echo():
				contextual_menu.popup()
				contextual_menu.rect_global_position = get_global_mouse_position()

func connection_request(from, from_slot, to, to_slot):
	# Remove existing connections

	for connection in graph_editor.get_connection_list():
		if (connection["from"] == from and connection["from_port"] == from_slot):
			var node = graph_editor.get_node(connection["from"])
			if not node.allows_multinode:
				graph_editor.disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])

	graph_editor.connect_node(from, from_slot, to, to_slot)
	save_to_resource()
func edit(object):
	if object:
		if object is ERODialog:
			editing_object = object
			load_from_resource()

func save_to_resource():
	# Reset stuff
	editing_object.node_data = {}
	editing_object.connection_list = []

	# Save nodes
	for node in graph_editor.get_children():
		if node is GraphNode:
			editing_object.add_from_node(node)
	# Save connections
	editing_object.connection_list = graph_editor.get_connection_list()
func clear():
	for child in graph_editor.get_children():
		if child.has_method("get_dialog_node_type"):
			child.free()

func create_node(type, node_data=null):
		# Create the nodes
		print(type)
		var node_type = plugin.get_dialog_node_of_type(type)
		var new_node = node_type.new()
		if new_node.is_unique():
			for node in graph_editor.get_children():
				if node is node_type:
					return
		if node_data:
			new_node.name = node_data["name"]
			new_node.offset = node_data["offset"]
			new_node.from_dict(node_data["data"])
		
		new_node.connect("on_node_update", self, "save_to_resource")
		
		graph_editor.add_child(new_node)
		
		
		return new_node

func load_from_resource():
	clear()
	graph_editor.clear_connections()
	if editing_object:
		for node_name in editing_object.node_data:
			create_node(editing_object.node_data[node_name]["type"], editing_object.node_data[node_name])

			# Connect them
			for connection in editing_object.connection_list:
				graph_editor.connect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])