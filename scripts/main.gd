extends Node3D
class_name Main

@export var debug_info : bool = false

@onready var cam_anim: AnimationPlayer = $Camera3D/AnimationPlayer
@onready var arena: Arena = $Arena
@onready var opp_sprite: AnimatedSprite3D = $Opp/Sprite3D
@onready var tournament_anim: AnimationPlayer = $Tournament/AnimationPlayer
@onready var t_opps: Control = $Tournament/TUI/Back/Opps

const WALL_2 = preload("uid://w18si25raseq")
const TABLE_2 = preload("uid://y33lbecgby21")

const TABLE_3 = preload("uid://r1m6h8q2ca0h")
const WALL_3 = preload("uid://x8u7stte1w14")

var current_game : int = 0

func _ready() -> void:
	randomize()
	
	CardList.assign_textures()
	if debug_info:
		CardList.debug_set_cardnames()
	arena.set_up_round(96, Color.WHITE)
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
	
	## New opponent arena
	current_game += 1
	set_new_opponent()
	
	var tween : Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(t_opps, "position", Vector2(t_opps.position.x, t_opps.position.y + 128), 2.0)
	await tween.finished
	
	await get_tree().create_timer(3.0, false).timeout
	
	tournament_anim.play("start_round")
	await tournament_anim.animation_finished
	
	arena.new_game()

func set_new_opponent() -> void:
	match current_game:
		1:
			$Room/LeftWall.set_surface_override_material(0, WALL_2)
			$Room/RightWall.set_surface_override_material(0, WALL_2)
			$Room/ForwardWall.set_surface_override_material(0, WALL_2)
			$Room/Table.set_surface_override_material(0, TABLE_2)
			$Opp/Sprite3D.sprite_frames = load("res://textures/opp2.tres")
			opp_sprite.play("idle")
			arena.set_up_round(144, Color.CYAN)
		2:
			$Room/LeftWall.set_surface_override_material(0, WALL_3)
			$Room/RightWall.set_surface_override_material(0, WALL_3)
			$Room/ForwardWall.set_surface_override_material(0, WALL_3)
			$Room/Table.set_surface_override_material(0, TABLE_3)
			$Opp/Sprite3D.sprite_frames = load("res://textures/opp3.tres")
			opp_sprite.play("idle")
			arena.set_up_round(192, Color.RED)
