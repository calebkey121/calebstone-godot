extends Node2D

var card_data = {}

func _ready():
	card_data = load_data_from_json("res://cards.json")

func load_data_from_json(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		var data = JSON.parse_string(json)
		return data
	else:
		print("File not found: " + file_path)
