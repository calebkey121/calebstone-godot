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
	var reset_hand_button = DummyHand.get_node("ResetHandButton")
	draw_button.pressed.connect(draw_card)
	draw_hand_button.pressed.connect(draw_hand)
	draw_deck_button.pressed.connect(draw_deck)
	hand_item_list.item_selected.connect(remove_card)
	reset_hand_button.pressed.connect(reset)

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

func remove_card(index: int):
	$hand.remove_card(index)

func remove_all_cards():
	while $hand.hand_count > 0:
		remove_card(0)

func reset():
	$hand.remove_all_cards()
