extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_name_mouse_entered():
	self.start()


func _on_card_name_mouse_exited():
	self.stop()
