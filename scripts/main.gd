extends Node3D
class_name Main

@onready var cam_anim: AnimationPlayer = $Camera3D/AnimationPlayer
@onready var arena: Arena = $Arena
@onready var opp_sprite: AnimatedSprite3D = $Opp/Sprite3D
@onready var tournament_anim: AnimationPlayer = $Tournament/AnimationPlayer
@onready var t_opps: Control = $Tournament/TUI/Back/Opps


func _ready() -> void:
	randomize()
	
	CardList.assign_textures()
	arena.deal_cards()
	opp_sprite.play("idle")

func to_table() -> void:
	cam_anim.play("to_table")

func from_table() -> void:
	cam_anim.play_backwards("to_table")

func _on_arena_hand_completed() -> void:
	if arena.player_score > arena.opp_score:
		opp_sprite.play("losing")
	elif arena.player_score < arena.opp_score:
		opp_sprite.play("winning")
	else:
		opp_sprite.play("idle")

func face_next_opponent() -> void:
	tournament_anim.play("to_tournament")
	await tournament_anim.animation_finished
	arena.reset()
	
	var tween : Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(t_opps, "position", Vector2(t_opps.position.x, t_opps.position.y + 112), 2.0)
	await tween.finished
	
	await get_tree().create_timer(3.0, false).timeout
	
	tournament_anim.play("start_round")
	await tournament_anim.animation_finished
