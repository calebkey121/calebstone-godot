extends Node2D

class_name Deck

var deck_count: int = 0
var original_deck_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_deck_visualization():
	var percentage: float = float(deck_count) / float(original_deck_count)
	if percentage > 0.8:
		return # leave alone
	elif percentage > 0.6:
		self.get_child(4).visible = false
	elif percentage > 0.4:
		self.get_child(3).visible = false
	elif percentage > 0.2:
		self.get_child(2).visible = false
	elif percentage > 0.0:
		self.get_child(1).visible = false
	elif percentage == 0.0:
		self.get_child(0).visible = false
