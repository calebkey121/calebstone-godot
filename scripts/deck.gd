extends Node2D

class_name Deck

var deck_count: int = 0
var original_deck_count: int = 0
var deck_name: String = "shadows_of_the_necropolis"
var cards: Array[Card] = []
var card_frame: String = "card_frame"

# Called when the node enters the scene tree for the first time.
func _ready():
	create_cards_from_decklist()
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
	update_deck_visualization() # how many cards are visible for the deck ui
	return card

func draw_cards(num: int):
	var drawn_cards = []
	for i in range(num):
		drawn_cards.append(draw_card())
	return drawn_cards

func update_deck_visualization():
	var percentage: float = float(deck_count) / float(original_deck_count)
	if percentage > 0.8:
		return # leave alone
	elif percentage > 0.6:
		self.get_child(4).visible = false
	elif percentage > 0.4:
		self.get_child(3).visible = false
	elif percentage > 0.2:
		self.get_child(2).visible = false
	elif percentage > 0.0:
		self.get_child(1).visible = false
	elif percentage == 0.0:
		self.get_child(0).visible = false

# Prep
func create_cards_from_decklist():
	var card_names = []
	var decklist = Tools.load_data_from_json("res://decklists/" + deck_name + ".json")
	for card_name in decklist:
		for i in range(decklist[card_name]): # how many instances of each card
			card_names.append(card_name)
	
	deck_count = len(card_names)
	original_deck_count = deck_count
	cards = CardManager.create_cards(card_names, card_frame)


# repr
func print_deck():
	var card_names = []
	for card in cards:
		card_names.append(card.card_name)
	print(card_names)
