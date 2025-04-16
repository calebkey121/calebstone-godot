extends Node

class_name DummyHand

var cards: Array[String] = []
var MAX_HAND_SIZE = 10

# Function to get the current number of cards in hand
func get_card_count() -> int:
	return cards.size()

# Function to get the maximum hand size
func get_max_size() -> int:
	return MAX_HAND_SIZE

# Function to clear all cards from hand
func clear_hand() -> void:
	cards.clear()
	$HandList.clear()

# Function to add a card to the hand
# Returns true if successfully added, false if hand is full
func add_card(card: String) -> bool:
	if get_card_count() >= MAX_HAND_SIZE:
		return false
	
	cards.append(card)
	$HandList.add_item(card)
	return true

# Function to bulk add cards to the hand
# Returns array of cards that couldn't be added (if hand becomes full)
func add_cards(new_cards: Array[String]) -> Array[String]:
	var rejected_cards: Array[String] = []
	
	for card in new_cards:
		if !add_card(card):
			rejected_cards.append(card)
	
	return rejected_cards

# Function to remove a specific card from the hand
# Returns true if card was found and removed, false otherwise
func remove_card(index: int) -> bool:
	if index != -1:
		cards.remove_at(index)
		$HandList.remove_item(index)
		return true
	return false

# Function to get a card at a specific index
# Returns empty string if index is invalid
func get_card_at(index: int) -> String:
	if index >= 0 and index < cards.size():
		return cards[index]
	return ""

# Function to check if hand is full
func is_full() -> bool:
	return get_card_count() >= MAX_HAND_SIZE

# Function to check if hand is empty
func is_empty() -> bool:
	return cards.is_empty()

# Function to get all cards in hand
func get_all_cards() -> Array[String]:
	return cards
