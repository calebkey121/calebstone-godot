extends Node

class_name Hand

var hand_count: int = 0
var max_hand_size: int = 10
var cards: Array[Card] = []
var id: int = 1

var initial_y_position = 500  # Initial y position for the first card
var x_middle: int = 0
var pad: int = 15
var card_width: int = 211

@export var initial_card_pos = Vector2(100, 100)

# Just for testing
var deck:
	set(name):
		deck = Deck.new()
		deck.deck_name = name
		deck.create_cards_from_decklist()
		deck.shuffle()
		update_cards()

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	deck = "decklist_1"


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
	card.get_node("CanvasLayer").get_node("card_ui").position = initial_card_pos
	hand_count += 1
	add_child(card)
	update_cards()
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
	remove_child(cards[index])
	cards.pop_at(index)
	$hand_list.remove_item(index)
	hand_count -= 1
	update_cards()
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


func update_cards():
	# Add new card instances
	var initial_x_position = x_middle - (hand_count - 1) * (pad / 2 + card_width / 2)
	var x = initial_x_position
	var y = initial_y_position
	for i in range(len(cards)):
		var new_position = Vector2(x, y)
		var card = cards[i]
		card.anchor_position = new_position
		card.canvas_layer = i
		x += pad + card_width


# buttons
func _on_draw_button_pressed():
	var card = deck.draw_card()
	if add_card(card):
		$hand_list.add_item(card.card_name)


func _on_hand_list_item_activated(index):
	remove_card(index)


func _on_reset_button_pressed():
	remove_all_cards()
	deck = "decklist_1"
