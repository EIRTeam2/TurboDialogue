tool
extends "EROTreeNode.gd"

var input_area

var character_option_button

var is_ui_initialized = false

var node_data = {}

func to_dict():
	update_data_from_ui() # just in case...
	return node_data

func from_dict(dict):

	node_data["text"] = dict["text"]
	node_data["selected_character"] = dict["selected_character"]

	if Engine.editor_hint:
		add_ui_elements()
		update_ui_from_data()

# Popullates the UI from node_data
func update_ui_from_data():
	input_area.text = node_data["text"]
	character_option_button.select(node_data["selected_character"])

# Popullates node_data from the UI
func update_data_from_ui():
	node_data["text"] = input_area.text
	node_data["selected_character"] = character_option_button.get_selected_id()

func _ready():
	if Engine.editor_hint:
		set_slot(0, true, TYPE_NIL, Color(1.0,1.0,1.0), true, TYPE_NIL, Color(1.0,1.0,1.0))

		if not is_ui_initialized:
			add_ui_elements()

		title = "Speech"

func add_ui_elements():

	is_ui_initialized = true

	for child in get_children():
		remove_child(child)

	var options_container = VBoxContainer.new()
	options_container.margin_bottom = 100

	character_option_button = OptionButton.new()

	character_option_button.add_item("Player", 0)

	character_option_button.add_item("NPC1", 1)

	character_option_button.add_item("NPC2", 2)

	options_container.add_child(character_option_button)

	input_area = LineEdit.new()
	input_area.size_flags_horizontal = SIZE_EXPAND_FILL
	input_area.size_flags_vertical = SIZE_EXPAND_FILL
	input_area.rect_min_size = Vector2(200,0)

	character_option_button.connect("item_selected",self, "on_node_update")
	input_area.connect("text_changed",self, "on_node_update")
	add_child(options_container)
	add_child(input_area)


func on_node_update(a=null):
	update_data_from_ui()
	emit_signal("on_node_update")

static func get_dialog_node_type():
	return "SpeechNode"

func execute_node(dialog, connections=null):
	print("EXECUTE %s" % [node_data["text"]])

	# Example ERO-ONE specific implementation
	"""
	dialog.dialog_renderer.show_text(node_data["text"])
	dialog.dialog_renderer.connect("on_finish_displaying_text", self, "on_finish_execution", [dialog, connections], CONNECT_ONESHOT)
	"""
