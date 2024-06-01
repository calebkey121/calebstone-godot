extends Node

# Cards
var card_names: Array[String] = Tools.get_card_names()
var card_name: String = "Icelord of Despair"
var card: Card

# Frames
var frame_names: Array[String] = Tools.get_frame_names()
var frame_name: String = "card_frame"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_cards_to_list()
	add_frames_to_list()
	update_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func add_cards_to_list():
	for card_name in card_names:
		$cards.get_child(1).add_item(card_name)

func add_frames_to_list():
	for frame_name in frame_names:
		$frames.get_child(1).add_item(frame_name)

func update_card():
	if card:
		remove_child(self.get_node("Card"))
	card = CardManager.create_card(card_name, frame_name)
	add_child(card)

# Buttons
func _on_reset_button_pressed():
	pass

func _on_card_list_item_clicked(index, at_position, mouse_button_index):
	card_name = $cards.get_child(1).get_item_text(index)
	update_card()

func _on_frame_list_item_clicked(index, at_position, mouse_button_index):
	frame_name = $frames.get_child(1).get_item_text(index)
	update_card()
