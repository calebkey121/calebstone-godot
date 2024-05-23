extends Control  # Assuming this is the card area control node

var dragging = false
var drag_offset = Vector2()
var rect_position = self.position

signal click_drag(new_position: Vector2)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Check if the click is within the card's bounds
				print("here")
				dragging = true
				drag_offset = rect_position - event.position
			else:
				dragging = false

func _process(delta):
	if dragging:
		var mouse_pos = get_viewport().get_mouse_position()
		print(mouse_pos)
		rect_position = mouse_pos + drag_offset
		click_drag.emit(mouse_pos)
	else:
		click_drag.emit(null)
