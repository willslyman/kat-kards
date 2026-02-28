extends Control
class_name Arena

@onready var cursor: Area2D = $Cursor

var currently_hovered_card : Card = null

## Player Stats
var player_hand_size : int = 5
var player_cards : Array[Card] = []
@onready var player_card_holder: Node2D = $MyCards
const CARD = preload("uid://ct03lqcjb5p66")

func _ready() -> void:
	deal_cards()

func _process(_delta: float) -> void:
	cursor.position = get_global_mouse_position()
	var areas : Array[Area2D] = cursor.get_overlapping_areas()
	for area in areas:
		if area is Card:
			currently_hovered_card = area
	if areas.size() == 0:
		currently_hovered_card = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and currently_hovered_card:
		currently_hovered_card.select()

func deal_cards() -> void:
	for i in player_hand_size:
		var c : Card = CARD.instantiate()
		var card_pos : Vector2 = Vector2((100 * i) - (100 * (player_hand_size / 2.0)) + 50, 128)
		player_card_holder.add_child(c)
		c.position = card_pos
		
		card_pos.y = 0
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		tween.tween_property(c, "position", card_pos, 0.2)
		
		await tween.finished
