extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().root.get_child(0) == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
