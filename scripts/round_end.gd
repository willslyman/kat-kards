extends Control

var arena : Arena = null
const WIN_TOKEN = preload("uid://ctdh37hrl278q")
var tokens : Array = []

var game_num : int = 0
var opp_reg : int = 0

var player_wins : int = 0
var opp_wins : int = 0
var midway : float = 0.0

var opp_color : Color = Color.WHITE

@onready var texture_rect: TextureRect = $TextureRect
signal game_won
signal game_lost

func setup(a : Arena, opp_region : int = 96, opp_col : Color = Color.RED) -> void:
	arena = a
	opp_reg = opp_region
	midway = arena.max_games / 2.0
	opp_color = opp_col
	player_wins = 0
	opp_wins = 0
	game_num = 0
	
	for i in range(arena.max_games):
		var token_pos : Vector2 = Vector2((52 * i) - (52 * (arena.max_games / 2.0)) + (52/2.0), 60)
		token_pos.x += 320
		var w = WIN_TOKEN.instantiate()
		texture_rect.add_child(w)
		w.position = token_pos
		tokens.append(w)

## -1 if nothing
## 1 if player wins
## 0 if opp wins
func set_win(is_player : bool) -> int:
	if is_player:
		$TextureRect.self_modulate = Color.ORANGE
	else:
		$TextureRect.self_modulate = opp_color
	
	$TextureRect/PScore.text = str(arena.player_score)
	$TextureRect/OScore.text = str(arena.opp_score)
	
	$AnimationPlayer.play("show")
	await $AnimationPlayer.animation_finished
	
	var w = tokens[game_num]
	game_num += 1
	if is_player:
		player_wins += 1
		await w.set_win(48) # player
	else:
		opp_wins += 1
		await w.set_win(opp_reg)
	
	var status : int = -1
	if player_wins > midway:
		status = 0
		game_won.emit()
		$AnimationPlayer.play("gameover")
		$Win.play("win")
	elif opp_wins > midway:
		status = 1
		game_lost.emit()
		$AnimationPlayer.play("gameover")
		$Win.play("lose")
	else:
		await get_tree().create_timer(2.0, false).timeout
		$AnimationPlayer.play("hide")
	
	await $AnimationPlayer.animation_finished
	
	if status == 1:
		$Menu.show()
	
	return status

func reset() -> void:
	$AnimationPlayer.play("RESET")
	for token in tokens:
		token.queue_free()
	
	tokens = []

func _on_menu_pressed() -> void:
	arena.main._restart()
