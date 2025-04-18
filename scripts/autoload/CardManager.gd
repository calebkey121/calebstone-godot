extends Node2D

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

# Card Dragging System
signal card_drag_started(card)
signal card_drag_ended(card, dropped_area)
signal card_hovered(card)
signal card_unhovered(card)

var dragged_card: Card = null
var original_parent = null
var drag_offset = Vector2.ZERO
var original_position = Vector2.ZERO

# This function processes input events that haven't been handled by the GUI
# or other input handlers lower in the scene tree. Perfect for global actions.
func _unhandled_input(event):
	# Check if:
	# 1. We are currently dragging a card (dragged_card is not null)
	# 2. The event is a mouse button event
	# 3. It's the LEFT mouse button
	# 4. The button was RELEASED (event.pressed is false)
	if dragged_card != null and event is InputEventMouseButton and \
	   event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:

		# If all conditions are met, end the drag.
		end_drag()

		# Optional: Stop the event from propagating further if needed,
		# though usually not necessary for a drag release.
		# get_viewport().set_input_as_handled()

# Ensure update_drag_position is called if a drag is active
# Add this if you don't already have it somewhere
func _process(delta):
	# Smoothly update drag position using lerp if a card is being dragged
	if dragged_card != null:
		# Calculate the target position where the card should ideally be
		var target_pos = get_global_mouse_position() + drag_offset

		# Interpolate the card's current global position towards the target position
		# Settings.card_follow_speed determines how quickly it catches up
		# delta makes the movement frame-rate independent
		dragged_card.global_position = dragged_card.global_position.lerp(target_pos, Settings.card_follow_speed * delta)

# Returns whether a specific card is being dragged
func is_card_dragging(card: Card) -> bool:
	return dragged_card == card

# Returns whether any card is being dragged
func is_any_card_dragging() -> bool:
	return dragged_card != null

# Called when a card starts being dragged
func start_drag(card: Card):
	if dragged_card != null:
		end_drag()
		
	dragged_card = card
	original_parent = card.get_parent()
	original_position = card.global_position
	
	# Use the global UILayer autoload
	drag_offset = card.global_position - get_global_mouse_position()
	original_parent.remove_child(card)
	UILayer.canvas_layer.add_child(card)
	card.global_position = get_global_mouse_position() + drag_offset
	
	emit_signal("card_drag_started", card)

# Called when card is released
func end_drag():
	if dragged_card != null:
		var drop_areas = get_tree().get_nodes_in_group("card_drop_area")
		var valid_drop_area = null
		var current_mouse_pos = get_global_mouse_position() # Get mouse position once

		# Check if card is over a valid drop area
		for area in drop_areas:
			# Assuming area is either Area2D or Control
			var area_rect = Rect2()
			if area is Area2D and area.get_child_count() > 0 and area.get_child(0) is CollisionShape2D:
				# Crude approximation for Area2D, better to use signals if possible
				area_rect = area.get_child(0).get_shape().get_rect()
				area_rect.position += area.global_position - area_rect.size / 2.0 # Adjust for center origin
			elif area is Control:
				area_rect = area.get_global_rect()

			# Check if mouse pointer is inside the area's rectangle
			if area_rect.has_point(current_mouse_pos):
				valid_drop_area = area
				break

		# Store the card before clearing dragged_card
		var card = dragged_card
		dragged_card = null # Stop the _process update

		# --- Reparenting and Tweening Logic ---
		var current_parent = card.get_parent()
		var release_global_pos
		if current_parent:
			release_global_pos = card.global_position
			current_parent.remove_child(card) # Remove from UILayer

		if valid_drop_area != null:
			# Add to the new area FIRST
			valid_drop_area.add_child(card) # Or call valid_drop_area.add_card(card) if it handles parenting

			# Convert the global position where the drag was released
			# into the local coordinate space of the original parent (Hand).
			card.position = original_parent.to_local(release_global_pos)

			# 3. Now, start the tween from this correct starting local position
			#    to the card's known anchor_position within the hand.
			card.move_card(card.anchor_position, Settings.card_return_duration)

		else:
			# --- Return to Original Parent and Tween ---
			# 1. Add back to the original parent
			original_parent.add_child(card)

			# 2. <<< Set initial position correctly >>>
			# Convert the global position where the drag was released
			# into the local coordinate space of the original parent (Hand).
			card.position = original_parent.to_local(release_global_pos)

			# 3. Now, start the tween from this correct starting local position
			#    to the card's known anchor_position within the hand.
			card.move_card(card.anchor_position, Settings.card_return_duration)
			# --- End Tween ---

		emit_signal("card_drag_ended", card, valid_drop_area)
