extends Node

class_name Dummy_Deck

# The array of cards in the deck (strings).
var cards: Array = []
var decklists_path: String = "res://decklists/"
var current_deck: String = ""

@onready var cards_itemlist = $RemainingCards

func _ready():
	$DeckList/Decklists.item_selected.connect(_on_decklists_item_selected)
	# Start with a decklist already loaded
	load_decklist($DeckList/Decklists.get_item_metadata(0))

# Load the decklist from a JSON file and populate the deck.
func load_decklist(json_path: String):
	var file = FileAccess.open(json_path, FileAccess.READ)
	if file:  # FileAccess.open returns null if file doesn't exist
		current_deck = json_path # remember whats currently loaded
		var deck_data = JSON.parse_string(file.get_as_text())
		cards.clear()
		for card_name in deck_data:
			for i in range(deck_data[card_name]):
				cards.append(card_name)
			shuffle() # Shuffle the deck after loading (will update itemlist)
	else:
		print("Decklist file not found: ", json_path)

# Draw a card (pop the top card of the stack).
func draw_card() -> String:
	if cards.size() > 0:
		var returnCard = cards.pop_front() # Remove and return the first card
		updateRemainingCards()
		return returnCard
	else:
		print("Deck is empty!")
		return ""

# Shuffle the deck (randomizes the card order).
func shuffle():
	cards.shuffle()
	updateRemainingCards()

func updateRemainingCards():
	cards_itemlist.clear()
	for card in cards:
		cards_itemlist.add_item(card)

# Get the current size of the deck.
func get_deck_size() -> int:
	return cards.size()

# Check if the deck is empty.
func is_empty() -> bool:
	return cards.size() == 0

func _on_decklists_item_selected(index):
	load_decklist($DeckList/Decklists.get_item_metadata(index))

func _on_reset_button_pressed():
	load_decklist(current_deck)
