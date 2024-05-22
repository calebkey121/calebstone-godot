extends Node

class_name Deck

var deck_count: int = 0
var cards: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	create_cards_from_decklist("decklist_1")
	shuffle()


# Gameplay
func shuffle():
	cards.shuffle()


func draw_card():
	var card = cards.pop_front()
	if card == null:
		print("empty deck...")
	else:
		print("you drew " + card.card_name)
	deck_count -= 1
	return card


func draw_cards(num: int):
	var drawn_cards = []
	for i in range(num):
		drawn_cards.append(draw_card())
	return drawn_cards


# Prep
func create_cards_from_decklist(deck_name):
	var card_names = []
	var decklist = Tools.load_data_from_json("res://decklists/" + deck_name + ".json")
	for card_name in decklist:
		for i in range(decklist[card_name]): # how many instances of each card
			card_names.append(card_name)
	
	deck_count = len(card_names)
	cards = CardManager.create_cards(card_names)


# repr
func print_deck():
	var card_names = []
	for card in cards:
		card_names.append(card.card_name)
	print(card_names)


# Buttons
func _on_draw_button_pressed():
	draw_card()
	print_deck()


func _on_shuffle_button_pressed():
	shuffle()
	print_deck()
