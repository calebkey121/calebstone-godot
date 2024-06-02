extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var frame_names: Array[String] = Tools.get_frame_names()
	add_frames_to_list(frame_names)

func add_frames_to_list(frame_names: Array[String]):
	for frame_name in frame_names:
		$frame_list.add_item(frame_name)
