extends Node

var initial_x_position: int = -830  # Initial x position for the first card
var initial_y_position: int = -565  # Initial y position for the first card
var x_pad: int = 0
var y_pad: int = 0
var card_width: int = 211
var card_height: int = 280
var cards_in_row: int = 10

var deck_pos := Vector2(-1091, -568)
var card_origin_pos := Vector2(-1091, -568)
var DeckScene: PackedScene = preload("res://scenes/deck.tscn")
var selected_deck: String = "shadows_of_the_necropolis"

# Frames
var frame_name: String = "card_frame"

# Called when the node enters the scene tree for the first time.
func _ready():	
	new_deck(selected_deck)
	update_cards()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func update_cards():
	var x = initial_x_position
	var y = initial_y_position
	for i in range($Deck.deck_count):
		var card = $Deck.cards[i]
		card.anchor_position = Vector2(x, y)  # y position is fixed, x position changes
		x += card_width + x_pad
		if (i + 1) % cards_in_row == 0:
			y += card_height + y_pad
			x = initial_x_position

func new_deck(deck_name: String):
	var deck: Deck = DeckScene.instantiate()
	deck.deck_name = deck_name
	deck.card_frame = frame_name
	add_child(deck)
	deck.position = deck_pos
	for i in range($Deck.deck_count):
		var card = $Deck.cards[i]
		card.get_node("CanvasLayer").get_node("card_ui").position = card_origin_pos
		card.get_node("CanvasLayer").get_node("card_ui").get_node("card_name_label").visible = false
		add_child(card)

func remove_all_cards():
	for i in range($Deck.deck_count):
		var card = $Deck.cards[i]
		remove_child(card)


# Buttons
func _on_draw_button_pressed():
	var card = $Deck.draw_card()
	if card:
		remove_child(card)
		update_cards()

func _on_shuffle_button_pressed():
	$Deck.shuffle()
	update_cards()

func _on_reset_button_pressed():
	remove_all_cards() # remove all old card instances
	remove_child(self.get_node("Deck"))
	new_deck(selected_deck)
	update_cards()

func _on_deck_list_item_clicked(index, at_position, mouse_button_index):
	selected_deck = $decks/deck_list.get_item_text(index)

func _on_frame_list_item_clicked(index, at_position, mouse_button_index):
	frame_name = $frames/frame_list.get_item_text(index)
	for card in $Deck.cards:
		CardManager.adjust_card(card, frame_name)
