extends Node2D


var default_card_frame: String = "card_frame"
var CardScene = preload("res://scenes/card.tscn")

func create_cards(card_names: Array, card_frame: String = default_card_frame):
	var cards: Array[Card] = []
	for card_name in card_names:
		cards.append(create_card(card_name, card_frame))
	return cards

func create_card(card_name: String, card_frame: String = default_card_frame):
	var frame_data = Tools.load_data_from_json("res://card_data/card_frames.json")[card_frame]
	
	# Frame Adjustments
	var frame_adjustment = frame_data["frame_adjustment"]
	var frame_position: Vector2 = Vector2(frame_adjustment["position"]["x"], frame_adjustment["position"]["y"])
	var frame_scale: Vector2 = Vector2(frame_adjustment["scale"]["x"], frame_adjustment["scale"]["y"])
	
	# Art Adjustments
	var art_adjustment = frame_data["art_adjustment"]
	var art_region_rect = Rect2()
	if card_name in art_adjustment:
		var card = art_adjustment[card_name]
		art_region_rect = Rect2(Vector2(card["region_rect"]["x"], card["region_rect"]["y"]),
							Vector2(card["region_rect"]["width"], card["region_rect"]["height"]))
	else:
		var default = art_adjustment["default"]
		art_region_rect = Rect2(Vector2(default["region_rect"]["x"], default["region_rect"]["y"]),
								Vector2(default["region_rect"]["width"], default["region_rect"]["height"]))
	
	var art_position = Vector2()
	if card_name in art_adjustment:
		var card = art_adjustment[card_name]
		art_position = Vector2(card["position"]["x"], card["position"]["y"])
	else:
		var default = art_adjustment["default"]
		art_position = Vector2(default["position"]["x"], default["position"]["y"])
	
	var art_scale = Vector2()
	if card_name in art_adjustment:
		var card = art_adjustment[card_name]
		art_scale = Vector2(card["scale"]["x"], card["scale"]["y"])
	else:
		var default = art_adjustment["default"]
		art_scale = Vector2(default["scale"]["x"], default["scale"]["y"])
	
	var new_card = CardScene.instantiate()
	new_card.card_name = card_name
	var card_ui = new_card.get_node("CanvasLayer").get_node("card_ui")
	set_frame_texture(card_ui, card_frame, frame_position, frame_scale)
	set_card_texture(card_ui, card_name, art_region_rect, art_position, art_scale)
	card_ui.get_node("card_name_label").text = card_name
	return new_card


func set_card_texture(card_ui, texture: String, region: Rect2, position: Vector2, scale: Vector2):
	var art_texture = TextureManager.get_texture(texture)
	var card_art = card_ui.get_node("card_art")
	card_art.texture = art_texture
	card_art.region_enabled = true
	card_art.region_rect = region
	card_art.position = position
	card_art.scale = scale


func set_frame_texture(card_ui, frame_name: String, position: Vector2, scale: Vector2):
	var frame = card_ui.get_node("card_frame")
	frame.texture = TextureManager.get_texture(frame_name)
	frame.position = position
	frame.scale = scale
