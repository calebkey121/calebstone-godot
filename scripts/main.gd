extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var x_offset = 250  # Adjust this value to set the distance between cards
	var initial_x_position = -100  # Initial x position for the first card
	var initial_y_position = 0  # Initial y position for the first card
	
	var card_names = [ "Wyndhaven Enclave", "Underground Kingpin", "Ruthless Baronesse", "Plague Doctor", "Guild Enforcer", "Crown's Secretkeeper", "Forgebound Smith" ]
	var cards = CardManager.create_cards(card_names)
	for i in range(len(cards)):
		var card = cards[i]
		card.get_node("card_ui").position = Vector2(initial_x_position + i * x_offset, initial_y_position)  # y position is fixed, x position changes
		add_child(card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
