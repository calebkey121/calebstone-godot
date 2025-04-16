extends Control  # Assuming this is the card area control node

var dragging = false
var drag_offset = Vector2()
var rect_position = self.position

signal click_drag(new_position: Vector2)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Checks if the click is within the card's bounds
				dragging = true
				get_parent().z_index += 100
				drag_offset = rect_position + event.position
				#print("event.position: " + str(event.position))
				#print("rect_position: " + str(rect_position))
				#print("get_global_mouse_position(): " + str(get_global_mouse_position()))
			else:
				dragging = false
				get_parent().z_index -= 100

func _process(_delta):
	if dragging:
		var mouse_pos = get_global_mouse_position() + drag_offset
		click_drag.emit(mouse_pos)
	else:
		click_drag.emit(null)
