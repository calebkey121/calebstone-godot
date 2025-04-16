extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	for frame_name in Tools.get_frame_names():
		$Frames.add_item(frame_name)

func _on_frames_item_selected(index):
	Settings.set_card_frame($Frames.get_item_text(index))
