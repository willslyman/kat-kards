extends Node3D
class_name Main

@onready var cam_anim: AnimationPlayer = $Camera3D/AnimationPlayer
@onready var arena: Arena = $Arena
@onready var opp_sprite: AnimatedSprite3D = $Opp/Sprite3D

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
