extends Node2D

@onready var card_state = get_parent()  # Reference to the parent CardNode

# Variables to store the original scale and timer state
var is_expanded = false
var original_scale = Vector2()
var scale_value = 0.5
var expanded_scale = Vector2(scale_value, scale_value)
var z_value = 10

enum STATE { IDLE, READY, ATTACK, TARGET }
var border_colors = { 
	STATE.IDLE: Color("ffffff00"), 
	STATE.READY: Color("2cb6b6"), 
	STATE.ATTACK: Color("d32e51"),
	STATE.TARGET: Color("00be5b"),
}

var border_color:
	set(state):
		$border.default_color = border_colors[state]
		

# Called when the node enters the scene tree for the first time.
func _ready():
	card_state.state_change.connect(_on_card_state_change)
	original_scale = self.scale
	expanded_scale += original_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_card_state_change(new_state):
	border_color = new_state


func _on_card_area_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", expanded_scale, 0.15) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)
	self.z_index += z_value
	is_expanded = true


func _on_card_area_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", original_scale, 0.15) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)
	self.z_index -= z_value
	is_expanded = false
