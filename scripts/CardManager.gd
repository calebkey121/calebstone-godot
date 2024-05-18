extends Node2D

var CardScene = preload("res://scenes/card.tscn")
var PreloadTextures = preload("res://scripts/PreloadTextures.gd")

func _ready():
	var preload_instance = PreloadTextures.new()
	add_child(preload_instance)
	preload_instance.preload_textures()
	load_cards_from_json("res://cards.json", preload_instance.textures)

func load_cards_from_json(file_path, textures: Dictionary):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		var card_data = JSON.parse_string(json)
		create_cards(card_data, textures)
	else:
		print("File not found: " + file_path)

func create_cards(card_data: Array, textures: Dictionary):
	var x_offset = 250  # Adjust this value to set the distance between cards
	var initial_x_position = -100  # Initial x position for the first card
	var initial_y_position = 0  # Initial y position for the first card

	for i in range(card_data.size()):
		var card = card_data[i]
	   # Set region_rect to null if the key is not present
		var region_rect = Rect2()
		if "region_rect" in card:
			region_rect = Rect2(Vector2(card["region_rect"]["x"], card["region_rect"]["y"]),
								Vector2(card["region_rect"]["width"], card["region_rect"]["height"]))
		
		var position = Vector2()
		if "position" in card:
			position = Vector2(card["position"]["x"], card["position"]["y"])
		
		var scale = Vector2()
		if "scale" in card:
			scale = Vector2(card["scale"]["x"], card["scale"]["y"])

		var card_instance = create_card(textures[card["frame_texture"]], textures[card["art_texture"]], card["name"], region_rect, position, scale)
		card_instance.get_node("card_ui").position = Vector2(initial_x_position + i * x_offset, initial_y_position)  # y position is fixed, x position changes
		add_child(card_instance)

func create_card(frame_texture: Texture, art_texture: Texture, card_name: String, region_rect: Rect2, position: Vector2, scale: Vector2 ): # , stats: Dictionary
	var new_card = CardScene.instantiate()
	var card_ui = new_card.get_node("card_ui")
	card_ui.get_node("card_frame").texture = frame_texture
	card_ui.set_card_texture(art_texture, region_rect, position, scale)
	card_ui.get_node("card_name").text = card_name
	add_child(new_card)
	return new_card
