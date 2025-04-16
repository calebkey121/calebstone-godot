extends Node

var decklists_path: String = "res://decklists/"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_all_decklists()

func load_all_decklists():
	$Decklists.clear()
	var dir = DirAccess.open(decklists_path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir():
				var i = $Decklists.add_item(file.get_basename())
				$Decklists.set_item_metadata(i, decklists_path + file)
			file = dir.get_next()
