extends Control

# Signal for transitioning to the game scene
signal game_started(game_data)

@onready var new_game_button = $NewGameButton
@onready var quit_button = $QuitButton
@onready var http_request = $HTTPRequest
@onready var session_list = $SessionList
var current_request: String

func _ready():
	# Connect button signals
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	# Connect HTTPRequest signals
	http_request.request_completed.connect(_on_http_request_completed)
	
	# Get any already running sessions on the server
	current_request = "get_all_sessions"
	NetworkManager.get_all_sessions($HTTPRequest)

# Quit game button functionality
func _on_quit_button_pressed():
	get_tree().quit()

# Start game button functionality
func _on_new_game_button_pressed():
	current_request = "new_game"
	NetworkManager.new_game($HTTPRequest, "human", "random")

# Callback for when the HTTP request completes
func _on_http_request_completed(result, response_code, headers, body):
	if response_code == 200:  # HTTP OK
		var response = JSON.parse_string(body.get_string_from_utf8())
		if current_request == "new_game":
			var session_id = response["session_id"]
			
			# Load the session data
			current_request = "load_game"
			NetworkManager.load_game($HTTPRequest, session_id)
		elif current_request == "get_all_sessions":
			for session in response:
				session_list.add_item(session)
	else:
		print("Failed to start game. HTTP Code:", response_code)

# Transition to the game scene
func _load_game_scene():
	var err = get_tree().change_scene_to_file("res://scenes/game.tscn")
	if err != OK:
		push_error("Failed to change to Menu scene: %s" % err)

func _on_session_list_item_selected(index):
	GameState.session_id = session_list.get_item_text(index)

func _on_load_game_button_pressed():
	_load_game_scene()
