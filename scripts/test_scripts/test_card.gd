extends Node

# Cards
@onready var card_data: CardData = Tools.get_card_data("Icelord of Despair")
@onready var card: Card = $Card
# Called when the node enters the scene tree for the first time.
func _ready():
	$FrameList/Frames.item_selected.connect(_on_frame_list_item_selected)
	$AllCardsList/AllCards.item_selected.connect(_on_card_list_item_selected)
	update_card()

func update_card():
	CardManager.adjust_card(card, card_data)

# Buttons
func _on_card_list_item_selected(index):
	card_data.name = $AllCardsList/AllCards.get_item_text(index)
	update_card()

func _on_frame_list_item_selected(index):
	update_card()
