extends Node

class_name Hand

var hand_count: int = 0
var max_hand_size: int = 10
var cards: Array[Card] = []
var id: int = 1

var initial_y_position = 0  # Initial y position for the first card
var x_middle: int = 0
var pad: int = 10
var card_width: int = 211

# Just for testing
var deck: Deck = Deck.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	
	deck.create_cards_from_decklist("decklist_1")
	deck.shuffle()
	for fuck_you in range(1):
		var card = deck.draw_card()
		if add_card(card):
			var card_children = card.get_children()
			var card_ui = card.get_child(1)
			var frame = card_ui.get_child(0)
			print(card_children)
			$hand_list.add_item(card.card_name)
	update_cards()


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
	add_child(card)
	update_cards()
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
	remove_child(cards[index])
	cards.pop_at(index)
	hand_count -= 1
	update_cards()
	return true


# repr
func print_hand():
	var card_names = []
	for i in range(len(cards)):
		var card = cards[i]
		card_names.append(str(i) + ": " + card.card_name)
	print(card_names)


func update_cards():
	# Remove all existing instances
	#for child in get_children():
	#	if child is Card:
	#		remove_child(child)


	# Add new card instances
	var initial_x_position = x_middle - (hand_count - 1) * (pad / 2 + card_width / 2)
	var x = initial_x_position
	var y = initial_y_position
	for i in range(len(cards)):
		var card = cards[i]
		var card_ui = card.get_node("card_ui")
		card_ui.position = Vector2(x, y)  # y position is fixed, x position changes
		x += pad + card_width

	# Debug: Print all children
	#print("Children after update:")
	#for child in get_children():
	#	if child is Card:
	#		#print(child)


func _on_draw_button_pressed():
	var card = deck.draw_card()
	if add_card(card):
		$hand_list.add_item(card.card_name)


func _on_hand_list_item_activated(index):
	if play_card(index):
		$hand_list.remove_item(index)

