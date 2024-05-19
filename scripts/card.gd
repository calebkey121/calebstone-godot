extends Node

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


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene == self:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_area_focus_entered():
	state = STATE.READY


func _on_card_area_focus_exited():
	state = STATE.IDLE
