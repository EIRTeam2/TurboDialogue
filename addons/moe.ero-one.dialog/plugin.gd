tool
extends EditorPlugin

const DIALOG_NODE_SCRIPTS = [
	preload("res://addons/moe.ero-one.dialog/Nodes/DialogSpeechNode.gd"), 
	preload("res://addons/moe.ero-one.dialog/Nodes/InputNode.gd"),
	preload("res://addons/moe.ero-one.dialog/Nodes/RandomChoiceNode.gd")
]

var DialogTree = preload("res://addons/moe.ero-one.dialog/ERODialogTree.gd")

var ERODialog = preload("res://addons/moe.ero-one.dialog/ERODialog.gd")

const dialog_editor_scene = preload("res://addons/moe.ero-one.dialog/Scenes/DialogEditor.tscn")

var dialog_editor

var icon = preload("res://addons/moe.ero-one.dialog/icon.png")

func _enter_tree():
	add_custom_type("ERODialogTree", "Node", DialogTree, null)
	add_custom_type("ERODialog", "Resource", ERODialog, null)
	dialog_editor = dialog_editor_scene.instance()
	dialog_editor.plugin = self
	get_editor_interface().get_editor_viewport().add_child(dialog_editor)
	
	make_visible(false)

func _exit_tree():
	remove_custom_type("ERODialogTree")
	remove_custom_type("ERODialog")
	dialog_editor.queue_free()
	
func handles(object):
	if object is DialogTree:
		if object.dialog:
			return true
	return false
	
func edit(object):
	if object is DialogTree:
		dialog_editor.edit(object.dialog)
	
func has_main_screen():
	return true
	
func make_visible(visible):
	if dialog_editor:
		dialog_editor.visible = visible
		
func get_plugin_name():
	return "Dialog"
	
func get_plugin_icon():
	return icon

static func get_dialog_node_of_type(type):
	for node_type in DIALOG_NODE_SCRIPTS:
		if node_type.get_dialog_node_type() == type:
			return node_type
			