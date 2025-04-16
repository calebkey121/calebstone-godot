extends Node

# Information
var frames: Array = []
var cards: Array = []

# Settings
var pad: int = 10
var card_width: int = 105
var card_frame: String = "card_frame"
var hero_frame: String = "card_frame_10"

# Called when the node enters the scene tree for the first time.
func _ready():
	categorize_textures(TextureManager.textures)

func set_card_frame(frame: String) -> void:
	card_frame = frame

func set_hero_frame(frame: String) -> void:
	hero_frame = frame

func categorize_textures(textures: Dictionary):
	# Loop through the dictionary keys
	for key in textures.keys():
		if key.begins_with("card_frame"):
			frames.append(key)
		else:
			cards.append(key)
