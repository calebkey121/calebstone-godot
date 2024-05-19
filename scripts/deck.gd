extends Node

var deck_count: int = 0
var cards = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	
	var deck_name = "decklist_1"
	cards = create_card_from_decklist(deck_name)
	shuffle()
	print_deck()


func draw_cards():
	var x_offset = 250  # Adjust this value to set the distance between cards
	var y_offset = 300
	var initial_x_position = -1000  # Initial x position for the first card
	var initial_y_position = -600  # Initial y position for the first card
	
	var x = initial_x_position
	var y = initial_y_position
	for i in range(len(cards)):
		var card = cards[i]
		card.get_node("card_ui").position = Vector2(x, y)  # y position is fixed, x position changes
		add_child(card)
		x += x_offset
		if (i + 1) % 10 == 0:
			y += y_offset
			x = initial_x_position


func create_card_from_decklist(deck_name):
	var card_names = []
	var decklist = Tools.load_data_from_json("res://decklists/" + deck_name + ".json")
	for card_name in decklist:
		for i in range(decklist[card_name]): # how many instances of each card
			card_names.append(card_name)
	
	deck_count = len(card_names)
	return CardManager.create_cards(card_names)

func shuffle():
	cards.shuffle()
	print_deck()


func _on_shuffle_button_pressed():
	shuffle()


func print_deck():
	for card in cards:
		print(card.card_name)


func draw_card():
	var card = cards.pop_front()
	if card == null:
		print("empty deck...")
	else:
		print("you drew " + card.card_name)
	return card


func _on_draw_cards_button_pressed():
	draw_cards()


func _on_draw_button_pressed():
	draw_card()
