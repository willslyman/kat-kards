extends Node3D
class_name Main

@onready var cam_anim: AnimationPlayer = $Camera3D/AnimationPlayer
@onready var arena: Arena = $Arena

func _ready() -> void:
	CardList.assign_textures()
	
	arena.deal_cards()

func to_table() -> void:
	cam_anim.play("to_table")

#func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("ui_accept"):
#		$Camera3D/AnimationPlayer.play("to_table")
#	elif Input.is_action_just_pressed("ui_cancel"):
#		$Camera3D/AnimationPlayer.play_backwards("to_table")
