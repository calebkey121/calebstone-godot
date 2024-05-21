extends Node

class_name Hand

var hand_count: int = 0
var max_hand_size: int = 10
var cards = []

# Just for testing
var deck: Deck = Deck.new("decklist_1")

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	print_hand()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func play_card(index: int):
	if index < 0 or index >= hand_count:
		return false
	cards.pop_at(index)
	hand_count -= 1
	return true


# repr
func print_hand():
	var card_names = []
	for i in range(len(cards)):
		var card = cards[i]
		card_names.append(str(i) + ": " + card.card_name)
	print(card_names)


func _on_draw_button_pressed():
	var card = deck.draw_card()
	if add_card(card):
		$hand_list.add_item(card.card_name)


func _on_hand_list_item_activated(index):
	if play_card(index):
		$hand_list.remove_item(index)

