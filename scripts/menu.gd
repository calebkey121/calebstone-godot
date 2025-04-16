extends Control

# Signal for transitioning to the game scene
signal game_started(game_data)

@onready var start_button = $StartButton
@onready var quit_button = $QuitButton
@onready var http_request = $HTTPRequest
var current_request = "start_game"

func _ready():
	# Connect button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	# Connect HTTPRequest signals
	http_request.request_completed.connect(_on_http_request_completed)

# Quit game button functionality
func _on_quit_button_pressed():
	get_tree().quit()

# Start game button functionality
func _on_start_button_pressed():
	NetworkManager.start_new_game($HTTPRequest, "human", "random")

# Callback for when the HTTP request completes
func _on_http_request_completed(result, response_code, headers, body):
	if response_code == 200:  # HTTP OK
		var response = JSON.parse_string(body.get_string_from_utf8())
		#print(response)
		if current_request == "start_game":
			var session_id = response["session_id"]
			print("Game started with session_id:", session_id)
			
			# Load the session data
			current_request = "get_game_state"
			NetworkManager.load_game($HTTPRequest, session_id)
		else:
			# Emit the signal with game data
			_load_game_scene(response)
	else:
		print("Failed to start game. HTTP Code:", response_code)

# Transition to the game scene
func _load_game_scene(game_data):
	var game_scene = preload("res://scenes/game.tscn").instantiate()  # Replace with your game scene path
	get_tree().root.add_child(game_scene)
	get_tree().get_current_scene().queue_free()  # Free the previous scene
	game_scene.setup(game_data)  # Pass the game data to the new scene (add a setup method in the game scene)
