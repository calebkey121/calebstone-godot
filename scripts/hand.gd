extends Node

class_name Hand

var hand_count: int = 0
var max_hand_size: int = 10
var cards: Array[Card] = []

# Hand locations... don't really like this rn
var y_pos = -500  # Initial y position
var x_middle: int = 0
var pad: int = 15
var card_width: int = 211

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

# create from a list of actual cards, or the json object
func add_cards(card_array):
	for card in card_array:
		if hand_count == max_hand_size or card == null:
			return false
		if typeof(card) == TYPE_DICTIONARY:
			card = CardManager.create_card(card["name"])
		var inserted = add_card(card)
		if not inserted:
			return false
	for card in cards:
		add_child(card)
	update_card_positions()
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


func update_card_positions():
	# Add new card instances
	var initial_x_position = x_middle - (hand_count - 1) * (pad / 2 + card_width / 2)
	var x = initial_x_position
	var y = y_pos
	for i in range(len(cards)):
		var new_position = Vector2(x, y)
		var card = cards[i]
		card.anchor_position = new_position
		card.canvas_layer = i
		x += pad + card_width
