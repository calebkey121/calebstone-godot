extends Node

var initial_y_position = 500  # Initial y position for the first card
var x_middle: int = 0
var pad: int = 15
var card_width: int = 211

# Deck
var deck_pos := Vector2(0, -568)
var card_origin_pos := Vector2(0, -568)
var DeckScene: PackedScene = preload("res://scenes/deck.tscn")
var selected_deck: String = "shadows_of_the_necropolis"

# Hand
var HandScene: PackedScene = preload("res://scenes/hand.tscn")

# Frames
var frame_name: String = "card_frame"

# Called when the node enters the scene tree for the first time.
func _ready():
	new_deck(selected_deck)
	new_hand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_hand():
	var hand: Hand = HandScene.instantiate()
	add_child(hand)

func new_deck(deck_name: String):
	var deck: Deck = DeckScene.instantiate()
	deck.deck_name = deck_name
	deck.card_frame = frame_name
	deck.position = deck_pos
	add_child(deck)

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
	remove_child(self.get_node("Deck"))
	new_deck(selected_deck)
	update_cards()

# buttons
func _on_draw_button_pressed():
	var card = $Deck.draw_card()
	card.get_node("CanvasLayer").get_node("card_ui").position = card_origin_pos
	if $hand.add_card(card):
		$hand_list.add_item(card.card_name)
		add_child(card)
	update_cards()

func _on_hand_list_item_activated(index):
	remove_card(index)
	update_cards()

func _on_reset_button_pressed():
	reset()

func _on_deck_list_item_clicked(index, at_position, mouse_button_index):
	selected_deck = $decks/deck_list.get_item_text(index)
	reset()

func _on_frame_list_item_clicked(index, at_position, mouse_button_index):
	frame_name = $frames/frame_list.get_item_text(index)
	for card in $Deck.cards:
		CardManager.adjust_card(card, frame_name)
	reset()
