extends Control
class_name Arena

var main : Main = null
@onready var cursor: Area2D = $Cursor

var CARD = load("res://scenes/cards/plus_1.tscn")

const CENTER : Vector2 = Vector2(320, 240)
var currently_hovered_card : Card = null
@onready var card_anim: AnimationPlayer = $MyCards/AnimationPlayer

var playing_hand : bool = false

## Player Stats
var player_score : int = 0
var player_hand_size : int = 5
var player_cards : Array[Card] = []
@onready var player_card_holder: Node2D = $MyCards
@onready var player_label: RichTextLabel = $UI/PlayerLabel

var opponent_score : int = 0

func _ready() -> void:
	main = get_parent()
	deal_cards()

func _process(_delta: float) -> void:
	cursor.position = get_global_mouse_position()
	var areas : Array[Area2D] = cursor.get_overlapping_areas()
	for area in areas:
		if area is Card:
			currently_hovered_card = area
	if areas.size() == 0:
		currently_hovered_card = null
	
	if currently_hovered_card:
		pass
	
	## Set scores
	player_label.text = str(player_score)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and currently_hovered_card:
		currently_hovered_card.select()

func deal_cards() -> void:
	for i in player_hand_size:
		var c : Card = CARD.instantiate()
		var card_pos : Vector2 = Vector2((100 * i) - (100 * (player_hand_size / 2.0)) + 50, 128)
		player_card_holder.add_child(c)
		c.position = card_pos
		c.setup(self, true)
		
		card_pos.y = 0
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(c, "position", card_pos, 0.2)
		
		player_cards.append(c)
		
		await tween.finished

func _play_hand() -> void:
	if playing_hand: return
	playing_hand = true
	main.to_table()
	
	var selected_cards : Array[Card] = []
	for i in range(player_cards.size() - 1, -1, -1):
		var card : Card = player_cards[i]
		if card.selected:
			card.playing = true
			var pos : Vector2 = card.global_position
			player_cards.erase(card)
			player_card_holder.remove_child(card)
			add_child(card)
			card.position = pos
			selected_cards.append(card)
	card_anim.play("hide")
	
	## Move cards to center
	selected_cards.reverse()
	for i in selected_cards.size():
		var card : Card = selected_cards[i]
		var card_pos : Vector2 = Vector2((100 * i) - (100 * (selected_cards.size() / 2.0)) + 50, 0) + CENTER + Vector2(0,64)
		
		card.deselect_anim()
		
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(card, "position", card_pos, 0.5)
	
	## Score cards
	for i in selected_cards.size():
		var card : Card = selected_cards[i]
		card.score()
		await get_tree().create_timer(0.2, false).timeout

func add_points(is_player : bool, amount : int) -> void:
	if is_player:
		player_score += amount
	else:
		opponent_score += amount
