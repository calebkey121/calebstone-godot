extends Node

var CardScene = preload("res://scenes/card.tscn")
var HeroScene = preload("res://scenes/hero.tscn")

func create_cards(card_data_array: Array[CardData]):
	var cards: Array[Card] = []
	for card_data in card_data_array:
		cards.append(create_card(card_data))
	return cards

func create_card(card_data: CardData):
	var new_card = CardScene.instantiate()
	return adjust_card(new_card, card_data)

func create_hero(hero_data: CardData):
	var new_hero = HeroScene.instantiate()
	var hero_card = new_hero.get_child(0)
	hero_data.type = "hero"
	return adjust_card(hero_card, hero_data)

func adjust_card(card: Card, data: CardData):
	card.card_name = data.name
	card.attack = data.attack
	card.health = data.health
	card.cost = data.cost
	card.card_text = data.text
	var card_name = data.name # used for ease further down
	
	# Frame Adjustments
	var frame = Settings.card_frame if data.type == "card" else Settings.hero_frame
	var frame_data = Tools.load_data_from_json("res://card_data/card_frames.json")[frame]
	var frame_adjustment = frame_data["frame_adjustment"]
	var frame_position: Vector2 = Vector2(frame_adjustment["position"]["x"], frame_adjustment["position"]["y"])
	var frame_scale: Vector2 = Vector2(frame_adjustment["scale"]["x"], frame_adjustment["scale"]["y"])
	
	# Art Adjustments
	var art_adjustment = frame_data["art_adjustment"]
	var art_region_rect = Rect2()
	if card_name in art_adjustment:
		var card_adjust = art_adjustment[card_name]
		art_region_rect = Rect2(Vector2(card_adjust["region_rect"]["x"], card_adjust["region_rect"]["y"]),
							Vector2(card_adjust["region_rect"]["width"], card_adjust["region_rect"]["height"]))
	else:
		var default = art_adjustment["default"]
		art_region_rect = Rect2(Vector2(default["region_rect"]["x"], default["region_rect"]["y"]),
								Vector2(default["region_rect"]["width"], default["region_rect"]["height"]))
	
	var art_position = Vector2()
	if card_name in art_adjustment:
		var card_adjust = art_adjustment[card_name]
		art_position = Vector2(card_adjust["position"]["x"], card_adjust["position"]["y"])
	else:
		var default = art_adjustment["default"]
		art_position = Vector2(default["position"]["x"], default["position"]["y"])
	
	var art_scale = Vector2()
	if card_name in art_adjustment:
		var card_adjust = art_adjustment[card_name]
		art_scale = Vector2(card_adjust["scale"]["x"], card_adjust["scale"]["y"])
	else:
		var default = art_adjustment["default"]
		art_scale = Vector2(default["scale"]["x"], default["scale"]["y"])
	
	
	set_frame_texture(card, frame, frame_position, frame_scale)
	set_card_texture(card, card_name, art_region_rect, art_position, art_scale)
	card.get_node("card_name_label").text = card_name
	return card


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
