extends Node2D

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
@export var expandable := false
var base_z_index: float
var original_scale := Vector2()
var scale_value := 0.5
var expanded_scale := Vector2(scale_value, scale_value)
var anchor_position := Vector2()
var hovering: bool = false
var expanded: bool = false

@onready var clickable_area = $card_area

# Called when the node enters the scene tree for the first time.
func _ready():
	state_change.connect(_on_card_state_change)
	original_scale = self.scale
	anchor_position = self.position
	expanded_scale += original_scale
	
	# Connect mouse signals to the clickable area
	clickable_area.gui_input.connect(_on_clickable_area_input_event)
	clickable_area.mouse_entered.connect(_on_mouse_entered)
	clickable_area.mouse_exited.connect(_on_mouse_exited)

func _process(_delta):
	# Check if we should be expanded (either hovering or being dragged)
	var should_be_expanded = hovering || CardManager.is_card_dragging(self)
	
	# Update visual state accordingly
	if should_be_expanded && !expanded:
		expand()
	elif !should_be_expanded && expanded:
		shrink()

func move_card(new_position, duration: float = 0.15):
	if new_position == null:
		new_position = anchor_position
	
	var tween = create_tween()
	tween.tween_property(self, "position", new_position, duration) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)

func expand():
	if expandable:
		expanded = true
		print("%s expanding", [self.card_name])
		print("%s z_index before expanding = %s" % [self.card_name, self.z_index])
		self.z_index = 100 # Or any value > siblings' default (0)
		print("%s z_index after expanding = %s" % [self.card_name, self.z_index])
		var tween = create_tween()
		tween.tween_property(self, "scale", expanded_scale, 0.15) \
			.set_trans(Tween.TRANS_LINEAR) \
			.set_ease(Tween.EASE_IN_OUT)

func shrink():
	# Only shrink if not being dragged
	if !CardManager.is_card_dragging(self):
		expanded = false
		var tween = create_tween()
		tween.tween_property(self, "scale", original_scale, 0.15) \
			.set_trans(Tween.TRANS_LINEAR) \
			.set_ease(Tween.EASE_IN_OUT)
		self.z_index = base_z_index

func set_base_z_index(index: int):
	self.base_z_index = index
	# Apply immediately ONLY IF NOT currently hovering/being dragged
	# CardManager handles Z during drag via CanvasLayer
	if not hovering and not CardManager.is_card_dragging(self):
		self.z_index = index

# Signal Handlers
func _on_card_state_change(new_state):
	border_color = new_state

func _on_mouse_entered():
	# Ensure we're not currently dragging another card
	if !CardManager.is_any_card_dragging():
		hovering = true

func _on_mouse_exited():
	# Ensure we're not still dragging our card
	if !CardManager.is_card_dragging(self):
		hovering = false

func _on_clickable_area_input_event(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			CardManager.start_drag(self)
		elif CardManager.is_card_dragging(self):
			CardManager.end_drag()
