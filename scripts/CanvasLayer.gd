extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if $card_ui.hovering or $card_ui/card_area.dragging:
	#	self.layer = 100
	#else:
	#	self.layer = 0

func _on_card_area_mouse_entered():
	self.layer += 100


func _on_card_area_mouse_exited():
	self.layer -= 100
