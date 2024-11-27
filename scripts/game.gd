extends Node2D

var game_data = {}

# Preload Scenes
var HandScene: PackedScene = preload("res://scenes/hand.tscn")
var HeroScene: PackedScene = preload("res://scenes/hero.tscn")

@onready var new_game_button = $NewGameButton
@onready var quit_button = $QuitButton
@onready var http_request = $HTTPRequest
@onready var session_list = $SessionList
var current_request = "new_game"

func _ready():
	# Connect button signals
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	# Connect HTTPRequest signals
	http_request.request_completed.connect(_on_http_request_completed)
	
	# Get any already running sessions on the server
	get_all_sessions()

func setup(data):
	game_data = data
	print("Game scene initialized with data:", game_data)
	
	# Create and populate a new hand
	if $player1_hand:
		# clear existing cards
		# maybe have a $hand.clear_cards()
		remove_child($player1_hand)
		#$hand.queue_free() is this needed?
	if $player2_hand:
		remove_child($player2_hand)
	var player1_hand: Hand = HandScene.instantiate()
	player1_hand.name = "player1_hand"
	
	var player2_hand: Hand = HandScene.instantiate()
	player2_hand.name = "player2_hand"
	player2_hand.y_pos = -player2_hand.y_pos
	
	var player1_name = game_data["current_player"]["hero"]["name"]
	var player1_hero: Card = CardManager.create_hero(player1_name)
	var player2_name = game_data["opponent_player"]["hero"]["name"]
	var player2_hero: Card = CardManager.create_hero(player2_name)
	
	add_child(player1_hand)
	add_child(player2_hand)
	add_child(player1_hero)
	add_child(player2_hero)
	player1_hand.add_cards(game_data["current_player"]["hand"])
	player2_hand.add_cards(game_data["opponent_player"]["hand"])
	var hero1_pos := Vector2(-500, 200)
	var hero2_pos := Vector2(-500, -200)
	player1_hero.get_child(0).offset = hero1_pos
	player2_hero.get_child(0).offset = hero2_pos


func _on_quit_button_pressed():
	get_tree().quit()

func _on_new_game_button_pressed():
	var url = "http://127.0.0.1:5000/api/new_game"  # Replace with your server's URL
	current_request = "new_game"
	http_request.request(url, [], HTTPClient.METHOD_POST)

func load_game(session_id):
	current_request = "load_game"
	var url = "http://127.0.0.1:5000/api/game_state/%s" % [session_id]
	http_request.request(url)

func get_all_sessions():
	current_request = "get_all"
	var url = "http://127.0.0.1:5000/api/game_state"
	http_request.request(url)


# Callback for when the HTTP request completes
func _on_http_request_completed(result, response_code, headers, body):
	if response_code == 200:  # HTTP OK
		var response = JSON.parse_string(body.get_string_from_utf8())
		#print(response)
		if current_request == "new_game":
			var session_id = response["session_id"]
			print("Game started with session_id:", session_id)
			
			# Add to the session list
			session_list.add_item(session_id)
			
			# Load the session data
			load_game(session_id)
			
		elif current_request == "load_game":
			# Emit the signal with game data
			setup(response)
		
		elif current_request == "get_all":
			for session in response:
				session_list.add_item(session)


func _on_session_list_item_activated(index):
	var session_id = session_list.get_item_text(index)
	load_game(session_id)
