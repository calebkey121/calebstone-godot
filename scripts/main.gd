extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	
	var x_offset = 250  # Adjust this value to set the distance between cards
	var y_offset = 300
	var initial_x_position = -700  # Initial x position for the first card
	var initial_y_position = -250  # Initial y position for the first card
	
	var card_names = [
		"Wyndhaven Enclave",
		"Ruthless Baroness",
		"Underground Kingpin",
		"Crown's Secretkeeper",
		"Forgebound Smith",
		"Guild Enforcer",
		"Plague Doctor",
		"Bandit Outlaw",
		"Banshee's Wail",
		"Bone Collector",
		"Bow Marshal",
		"Castle Ward",
		"Court Alchemist",
		"Crypt Creeper",
		"Cursed Squire",
		"Dire Wolf",
		"Ghoul Vanguard",
		"Ghostly Raider",
		"Graveyard Sentinel",
		"Highland Scout",
		"Highwayman's Ambush",
		"Jousting Champion",
		"Mercenary Captain",
		"Mournful Spirit",
		"Necromancer of the Forgotten Depths",
		"Necromancer of the Vale",
		"Necropolis Guard",
		"Phantom Steed",
		"Revenant Archer",
		"Royal Falconer",
		"Shadow of the Past",
		"Siege Engineer",
		"Skeletal Knight",
		"Spectral Ferryman",
		"Tomb Warden",
		"Undead Creature",
		"Village Blacksmith",
		"Wandering Minstrel"
	];

	var cards = CardManager.create_cards(card_names)
	var x = initial_x_position
	var y = initial_y_position
	for i in range(len(cards)):
		var card = cards[i]
		card.get_node("card_ui").position = Vector2(x, y)  # y position is fixed, x position changes
		add_child(card)
		x += x_offset
		if (i + 1) % 11 == 0:
			y += y_offset
			x = initial_x_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
