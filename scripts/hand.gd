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
func add_card(data: CardData):
	var card = CardManager.create_card(data)
	if hand_count == max_hand_size or card == null:
		return false
	cards.append(card)
	hand_count += 1
	add_child(card)
	update_card_positions()
	return true

# create from a list of actual cards, or the json object
func add_cards(data_array: Array):
	for data in data_array:
		if hand_count >= max_hand_size or data == null or not data is CardData:
			return false
		var inserted = add_card(data)
		if not inserted:
			return false
	return true


func remove_card(index: int):
	if index < 0 or index >= hand_count:
		return false
	cards.pop_at(index)
	hand_count -= 1
	update_card_positions()
	return true


func remove_all_cards():
	while hand_count > 0:
		remove_card(0)


func update_card_positions():
	# Add new card instances
	var initial_x_position = - (hand_count - 1) * (Settings.pad / 2 + Settings.card_width / 2)
	var x = initial_x_position
	for i in range(len(cards)):
		var new_position = Vector2(x, 0)
		var card = cards[i]
		card.anchor_position = new_position
		# card.canvas_layer = i
		x += Settings.pad + Settings.card_width
