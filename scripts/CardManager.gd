extends Node2D

var card_data = Tools.load_data_from_json("res://card_data/cards.json")
var CardScene = preload("res://scenes/card.tscn")


func create_cards(card_names: Array):
	var cards = []
	for name in card_names:
		cards.append(create_card(name))
	return cards


func create_card(card_name: String):
	var card = card_data[card_name]
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

	# change this whole block to use new()/_init
	var new_card = CardScene.instantiate()
	new_card.card_name = card_name
	var card_ui = new_card.get_node("card_ui")
	set_frame_texture(card_ui, card["frame_texture"])
	set_card_texture(card_ui, card["art_texture"], region_rect, position, scale)
	card_ui.get_node("card_name").text = card_name
	return new_card


func set_card_texture(card_ui, texture: String, region: Rect2, position: Vector2, scale: Vector2):
	var art_texture = TextureManager.get_texture(texture)
	var card_art = card_ui.get_node("card_art")
	card_art.texture = art_texture
	if region == Rect2():
		card_art.region_enabled = false
	else:
		card_art.region_enabled = true
		card_art.region_rect = region
	if position != Vector2(): # find a better way, its reasonable to have position to 0,0
		card_art.position = position
	if scale != Vector2():
		card_art.scale = scale


func set_frame_texture(card_ui, frame_name: String):
	var frame = card_ui.get_node("card_frame")
	frame.texture = TextureManager.get_texture(frame_name)
	var frame_data = Tools.load_data_from_json("res://card_data/card_frames.json")[frame_name]
	var position: Vector2 = Vector2(frame_data["position"]["x"], frame_data["position"]["y"])
	var scale: Vector2 = Vector2(frame_data["scale"]["x"], frame_data["scale"]["y"])
	frame.position = position
	frame.scale = scale
