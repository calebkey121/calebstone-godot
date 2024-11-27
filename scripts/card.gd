extends Node

class_name Card

enum STATE { IDLE, READY, ATTACK, TARGET }

signal state_change(new_state)

@export var attack := 5
@export var health := 5
@export var cost := 5
@export var state: STATE:
	set(value):
		state = value
		state_change.emit(value)

var card_name = ""
var canvas_layer: int:
	set(value):
		$CanvasLayer.layer = value
var anchor_position: Vector2:
	set(value):
		$CanvasLayer.get_node("card_ui").anchor_position = value


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# Signal Handling
func _on_card_area_focus_entered():
	state = STATE.READY

func _on_card_area_focus_exited():
	state = STATE.IDLE
