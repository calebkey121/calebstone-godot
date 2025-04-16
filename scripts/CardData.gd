class_name CardData
extends Resource

var name: String
var attack: int
var health: int
var cost: int
var text: String
var art_texture: String
var type: String

# Converts raw dictionary to CardData
static func from_dict(data: Dictionary) -> CardData:
	var card_data = CardData.new()
	card_data.name = data.get("name", "")
	card_data.attack = data.get("attack", 0)
	card_data.health = data.get("health", 0)
	card_data.cost = data.get("cost", 0)
	card_data.text = data.get("text", "")
	card_data.type = "card"
	return card_data

static func from_dict_array(data_array: Array) -> Array:
	var card_data = []
	for data in data_array:
		card_data.append(from_dict(data))
	return card_data
