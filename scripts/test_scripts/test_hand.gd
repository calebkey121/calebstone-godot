extends Node

var initial_y_position = 500  # Initial y position for the first card
var x_middle: int = 0
var pad: int = 15
var card_width: int = 211

# Hand
var HandScene: PackedScene = preload("res://scenes/hand.tscn")
const DummyDeckScene = preload("res://scripts/tools/dummy_deck.gd")
var card_origin_pos := Vector2(0, 0)

# Frames
var frame_name: String = "card_frame"

@onready var DummyHand = $DummyHand
@onready var DummyDeck = $DummyDeck

# Called when the node enters the scene tree for the first time.
func _ready():
	var draw_button = DummyHand.get_node("DrawButton")
	var draw_hand_button = DummyHand.get_node("DrawHandButton")
	var draw_deck_button = DummyHand.get_node("DrawDeckButton")
	var hand_item_list = DummyHand.get_node("HandList")
	draw_button.pressed.connect(draw_card)
	draw_hand_button.pressed.connect(draw_hand)
	draw_deck_button.pressed.connect(draw_deck)

func draw_card():
	var card_name = DummyDeck.draw_card()
	DummyHand.add_card(card_name)
	$hand.add_card(Tools.get_card_data(card_name))

func draw_hand():
	var cards = DummyDeck.draw_hand()
	DummyHand.add_cards(cards)

func draw_deck():
	var cards = DummyDeck.draw_deck()
	DummyHand.add_cards(cards)

func update_cards():
	# Add new card instances
	var initial_x_position = x_middle - ($hand.hand_count - 1) * (pad / 2 + card_width / 2)
	var x = initial_x_position
	var y = initial_y_position
	for i in range(len($hand.cards)):
		var new_position = Vector2(x, y)
		var card = $hand.cards[i]
		card.anchor_position = new_position
		card.canvas_layer = i
		x += pad + card_width

func remove_card(index: int):
	remove_child($hand.cards[index])
	$hand.remove_card(index)
	$hand_list.remove_item(index)

func remove_all_cards():
	while $hand.hand_count > 0:
		remove_card(0)

func reset():
	remove_all_cards()
	update_cards()

# buttons
func _on_draw_button_pressed():
	draw_card()

func _on_hand_list_item_activated(index):
	remove_card(index)
	update_cards()

func _on_reset_button_pressed():
	reset()

#func _on_frame_list_item_clicked(index, at_position, mouse_button_index):
#	frame_name = $frames/frame_list.get_item_text(index)
#	for card in $Deck.cards:
#		CardManager.adjust_card(card, frame_name)
#	reset()

#func _on_draw_all_button_pressed():
#	while $Deck.deck_count > 0:
#		draw_card()

#func _on_draw_hand_pressed():
#	while $hand.hand_count < $hand.max_hand_size:
#		draw_card()
