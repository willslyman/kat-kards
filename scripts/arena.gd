extends Control
class_name Arena

var main : Main = null
@onready var cursor: Area2D = $Cursor

#var CARD = load("res://scenes/cards/plus_1.tscn")

const CENTER : Vector2 = Vector2(320, 240)
var currently_hovered_card : Card = null
@onready var card_anim: AnimationPlayer = $MyCards/AnimationPlayer

var playing_hand : bool = false

## Visual consts
const hand_card_gap : int = 100
const play_card_gap : int = 120

## Game Stats
var card_play_size : int = 3

## Player Stats
var player_score : int = 0
var player_hand_size : int = 5
var player_cards : Array[Card] = []
@onready var player_card_holder: Node2D = $MyCards
@onready var player_label: RichTextLabel = $UI/PlayerLabel

var current_cards_selected : int = 0
var player_selected_cards : Array[Card] = []

## Opp Stats
var opp_score : int = 0
var opp_selected_cards : Array[Card] = []


func _ready() -> void:
	main = get_parent()

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
		var card_name = CardList.card_list.keys().pick_random()
		var c : Card = CardList.card_list[card_name].instantiate()
		var card_pos : Vector2 = Vector2((hand_card_gap * i) - (hand_card_gap * (player_hand_size / 2.0)) + 50, 128)
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
	
	for i in range(player_cards.size() - 1, -1, -1):
		var card : Card = player_cards[i]
		if card.selected:
			card.playing = true
			var pos : Vector2 = card.global_position
			player_cards.erase(card)
			player_card_holder.remove_child(card)
			add_child(card)
			card.position = pos
			player_selected_cards.append(card)
	card_anim.play("hide")
	
	## Move cards to center
	player_selected_cards.reverse()
	for i in player_selected_cards.size():
		var card : Card = player_selected_cards[i]
		var card_pos : Vector2 = Vector2((play_card_gap * i) - (play_card_gap * (player_selected_cards.size() / 2.0)) + 50, 0) + CENTER + Vector2(0,64)
		
		card.deselect_anim()
		
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(card, "position", card_pos, 0.5)
	
	## Get opponent cards
	for i in card_play_size:
		var card_name = CardList.card_list.keys().pick_random()
		var c : Card = CardList.card_list[card_name].instantiate()
		add_child(c)
		c.playing = true
		c.position = Vector2(320,-128)
		c.setup(self, false)
		opp_selected_cards.append(c)
	
	await get_tree().create_timer(1.2, false).timeout 
	
	## Show opponent cards
	for i in range(opp_selected_cards.size()):
		var card : Card = opp_selected_cards[i]
		var card_pos : Vector2 = Vector2(320 + (play_card_gap * i) - (play_card_gap * (card_play_size / 2.0)) + 50, 128)
		#card.position = card_pos
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(card, "position", card_pos, 0.5)
		
	await get_tree().create_timer(1.0, false).timeout
	
	## Score cards
	for i in player_selected_cards.size():
		for card_type in CardList.card_list:
			if player_selected_cards[i].card_name == card_type:
				var card : Card = player_selected_cards[i]
				await do_card(card)
				
	for i in opp_selected_cards.size():
		for card_type in CardList.card_list:
			if opp_selected_cards[i].card_name == card_type:
				var card : Card = opp_selected_cards[i]
				await do_card(card)

func do_card(card : Card) -> void:
	if card.destroyed: return
	await card.use()
	card.un_use()
	await get_tree().create_timer(0.4, false).timeout

func add_points(is_player : bool, amount : int) -> void:
	if is_player:
		player_score += amount
	else:
		opp_score += amount

func add_mult(is_player : bool, mlt : int) -> void:
	if is_player:
		player_score *= mlt
	else:
		opp_score *= mlt
		
func destroy_player_card() -> void:
	var card_idxs = []
	for i in range(player_selected_cards.size()):
		card_idxs.append(i)
	card_idxs.shuffle()
	for i in card_idxs:
		if not player_selected_cards[i].destroyed:
			player_selected_cards[i].destroy()
			return

func destroy_opp_card() -> void:
	var card_idxs = []
	for i in range(opp_selected_cards.size()):
		card_idxs.append(i)
	card_idxs.shuffle()
	for i in card_idxs:
		if not opp_selected_cards[i].destroyed:
			opp_selected_cards[i].destroy()
			return
