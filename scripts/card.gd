extends Node

class_name Card

enum STATE { IDLE, READY, ATTACK, TARGET }
signal state_change(new_state)

var border_colors = { 
	STATE.IDLE: Color("ffffff00"), 
	STATE.READY: Color("2cb6b6"), 
	STATE.ATTACK: Color("d32e51"),
	STATE.TARGET: Color("00be5b"),
}
var border_color:
	set(state):
		$border.default_color = border_colors[state]

var card_name = ""
var card_text = ""
@export var attack := 5
@export var health := 5
@export var cost := 5
@export var state: STATE:
	set(value):
		state = value
		state_change.emit(value)

# ui
# Variables to store the original scale and timer state
var is_expanded := false
@export var expandable := false
var original_z: float
var original_scale := Vector2()
var scale_value := 0.5
var expanded_scale := Vector2(scale_value, scale_value)
var anchor_position := Vector2()
var hovering: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	state_change.connect(_on_card_state_change)
	original_scale = self.scale
	original_z = self.z_index
	anchor_position = self.position
	expanded_scale += original_scale
	
	$card_area.connect("click_drag", move_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func move_card(new_position, duration: float = 0.15):
	if new_position == null:
		new_position = anchor_position
		if not hovering:
			shrink()
	var tween = create_tween()
	tween.tween_property(self, "position", new_position, duration) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)

func expand():
	if expandable:
		var tween = create_tween()
		tween.tween_property(self, "scale", expanded_scale, 0.15) \
			.set_trans(Tween.TRANS_LINEAR) \
			.set_ease(Tween.EASE_IN_OUT)
		is_expanded = true

func shrink():
	if not $card_area.dragging:
		var tween = create_tween()
		tween.tween_property(self, "scale", original_scale, 0.15) \
			.set_trans(Tween.TRANS_LINEAR) \
			.set_ease(Tween.EASE_IN_OUT)
		is_expanded = false

# Signal Handling
func _on_card_state_change(new_state):
	border_color = new_state

func _on_card_area_mouse_entered():
	hovering = true
	expand()

func _on_card_area_mouse_exited():
	hovering = false
	shrink()
