extends Node

var canvas_layer: CanvasLayer

func _ready():
	canvas_layer = CanvasLayer.new()
	canvas_layer.name = "DragLayer"
	canvas_layer.layer = 100  # High number so it's on top
	var viewport_root := get_tree().get_root().get_child(0)  # the main Scene's root node
	viewport_root.add_child(canvas_layer)
