extends Node

enum STATE { IDLE, READY, ATTACK, TARGET }

signal state_change(new_state)

@export var attack := 5
@export var health := 5
@export var cost := 5
@export var state: STATE:
	set(value):
		state = value
		state_change.emit(value)


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().root.get_child(0) == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false


func create_cards(card_names: Array):
	for name in card_names:
		create_card(name)
	pass


func create_card(card_name: String):
	var card = CardManager.card_data["card_name"]
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

	# card["frame_texture"], card["art_texture"], card["name"], region_rect, position, scale
	var new_card = self.instantiate()
	var card_ui = new_card.get_node("card_ui")
	card_ui.get_node("card_frame").texture = TextureManager.get_texture(frame_texture)
	card_ui.set_card_texture(art_texture, region_rect, position, scale)
	card_ui.get_node("card_name").text = card_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_area_focus_entered():
	state = STATE.READY


func _on_card_area_focus_exited():
	state = STATE.IDLE
