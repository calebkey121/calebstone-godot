extends Node

class_name Hand

var hand_count: int = 0
var max_hand_size: int = 10
var cards: Array[Card] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Gameplay
func shuffle():
	cards.shuffle() 


func add_card(card: Card):
	if hand_count == max_hand_size or card == null:
		return false
	cards.append(card)
	hand_count += 1
	return true


func add_cards(card_array):
	for card in card_array:
		var inserted: bool = add_card(card)
		if not inserted:
			return false
	return true


func remove_card(index: int):
	if index < 0 or index >= hand_count:
		return false
	cards.pop_at(index)
	hand_count -= 1
	return true


func remove_all_cards():
	while hand_count > 0:
		remove_card(0)


# display
func print_hand():
	var card_names = []
	for i in range(len(cards)):
		var card = cards[i]
		card_names.append(str(i) + ": " + card.card_name)
	print(card_names)
