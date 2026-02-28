extends Control
class_name Arena

var main : Main = null
@onready var cursor: Area2D = $Cursor

#var CARD = load("res://scenes/cards/plus_1.tscn")

const CENTER : Vector2 = Vector2(320, 240)
var currently_hovered_card : Card = null
@onready var card_anim: AnimationPlayer = $MyCards/AnimationPlayer
@onready var play_button: Button = $PlayHand
@onready var hand_score_anim: AnimationPlayer = $UI/HandScores/AnimationPlayer
@onready var player_hand_score_anim: AnimationPlayer = $UI/HandScores/PlayerHandScore/AnimationPlayer
@onready var opp_hand_score_anim: AnimationPlayer = $UI/HandScores/OppHandScore/AnimationPlayer
@onready var phs_label: RichTextLabel = $UI/HandScores/PlayerHandScore
@onready var ohs_label: RichTextLabel = $UI/HandScores/OppHandScore
@onready var score_anim: AnimationPlayer = $UI/AnimationPlayer

var playing_hand : bool = false

## Visual consts
const hand_card_gap : int = 100
const play_card_gap : int = 120

## Game Stats
var card_play_size : int = 3

## Player Stats
var player_score : int = 0
var player_hand_score : int = 0
var player_hand_size : int = 5
var player_cards : Array[Card] = []
@onready var player_card_holder: Node2D = $MyCards
@onready var player_label: RichTextLabel = $UI/Scores/PlayerLabel
@onready var opp_label: RichTextLabel = $UI/Scores/OppLabel

var current_cards_selected : int = 0
var player_selected_cards : Array[Card] = []

## Opp Stats
var opp_score : int = 0
var opp_hand_score : int = 0
var opp_selected_cards : Array[Card] = []

## Signals
signal hand_completed

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and currently_hovered_card:
		currently_hovered_card.select()

func deal_cards() -> void:
	for i in player_hand_size:
		# Skip if card exists
		if i < player_cards.size() and player_cards[i] != null:
			continue
		
		var card_name = CardList.card_list.keys().pick_random()
		var c : Card = CardList.card_list[card_name].instantiate()
		var card_pos : Vector2 = Vector2((hand_card_gap * i) - (hand_card_gap * (player_hand_size / 2.0)) + (hand_card_gap/2.0), 128)
		player_card_holder.add_child(c)
		c.position = card_pos
		c.setup(self, true)
		
		card_pos.y = 0
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(c, "position", card_pos, 0.2)
		
		if player_cards.size() <= i:
			player_cards.append(c)
		else:
			player_cards[i] = c
		
		await tween.finished

func _play_hand() -> void:
	if playing_hand: return
	
	## Must play 3 cards
	var selected : int = 0
	for i in range(player_cards.size() - 1, -1, -1):
		var card : Card = player_cards[i]
		if card.selected:
			selected += 1
	if selected != 3:
		$MyCards/SelectCards/AnimationPlayer.play("angry")
		return
	
	playing_hand = true
	main.to_table()
	play_button.hide()
	player_hand_score = 0
	opp_hand_score = 0
	score_anim.play("hide")
	player_selected_cards = []
	opp_selected_cards = []
	phs_label.text = "0"
	ohs_label.text = "0"
	
	for i in range(player_cards.size() - 1, -1, -1):
		var card : Card = player_cards[i]
		if card.selected:
			card.playing = true
			var pos : Vector2 = card.global_position
			player_cards[i] = null
			player_card_holder.remove_child(card)
			add_child(card)
			card.position = pos
			player_selected_cards.append(card)
	card_anim.play("hide")
	
	## Move cards to center
	player_selected_cards.reverse()
	for i in player_selected_cards.size():
		var card : Card = player_selected_cards[i]
		var card_pos : Vector2 = Vector2((play_card_gap * i) - (play_card_gap * (player_selected_cards.size() / 2.0)) + (play_card_gap/2.0), 0) + CENTER + Vector2(0,90)
		
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
		var card_pos : Vector2 = Vector2(320 + (play_card_gap * i) - (play_card_gap * (card_play_size / 2.0)) + (play_card_gap/2.0), 160)
		#card.position = card_pos
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(card, "position", card_pos, 0.5)
	
	hand_score_anim.play("show")
	await get_tree().create_timer(1.0, false).timeout
	
	
	## Score cards
	for card_type in CardList.card_list:
		for i in player_selected_cards.size():
			if player_selected_cards[i].card_name == card_type:
				var card : Card = player_selected_cards[i]
				await do_card(card)
	
	for card_type in CardList.card_list:
		for i in opp_selected_cards.size():
			if opp_selected_cards[i].card_name == card_type:
				var card : Card = opp_selected_cards[i]
				await do_card(card)
	
	## Go Back
	var all_cards : Array[Card] = player_selected_cards + opp_selected_cards
	for card : Card in all_cards:
		var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel()
		tween.tween_property(card, "position", Vector2(card.position.x + 640, card.position.y), 0.5)
		tween.tween_property(card, "rotation_degrees", card.rotation_degrees + randf_range(-80, 80), 0.5)
		await get_tree().create_timer(0.1, false).timeout
	
	for card : Card in all_cards:
		card.queue_free()
	
	## Compute scores
	player_score += player_hand_score
	opp_score += opp_hand_score
	player_label.text = str(player_score)
	opp_label.text = str(opp_score)
	
	hand_completed.emit()
	current_cards_selected = 0
	hand_score_anim.play("hide")
	main.from_table()
	score_anim.play("show")
	card_anim.play("show")
	await card_anim.animation_finished
	deal_cards()
	play_button.show()
	playing_hand = false

func do_card(card : Card) -> void:
	if card.destroyed: return
	await card.use()
	card.un_use()
	await get_tree().create_timer(0.4, false).timeout

func add_points(is_player : bool, amount : int) -> void:
	if is_player:
		player_hand_score += amount
		player_hand_score_anim.play("score")
		phs_label.text = str(player_hand_score)
	else:
		opp_hand_score += amount
		opp_hand_score_anim.play("score")
		ohs_label.text = str(opp_hand_score)

func add_mult(is_player : bool, mlt : int) -> void:
	if is_player:
		player_hand_score *= mlt
		player_hand_score_anim.play("score")
		phs_label.text = str(player_hand_score)
	else:
		opp_hand_score *= mlt
		opp_hand_score_anim.play("score")
		ohs_label.text = str(opp_hand_score)
		
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
