extends Node


# Returns parsed json from file, as a dictionary
func load_data_from_json(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json = file.get_as_text()
		var data = JSON.parse_string(json)
		return data
	else:
		print("File not found: " + file_path)
