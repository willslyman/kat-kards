extends Area2D
class_name Card

var arena : Arena
var is_player : bool = false

var selected : bool = false
var playing : bool = false
@onready var anim: AnimationPlayer = $AnimationPlayer

func setup(a : Arena, ip : bool) -> void:
	arena = a
	is_player = ip

func select() -> void:
	if playing: return
	
	if !selected:
		anim.play("select")
	else:
		anim.play("deselect")
	selected = !selected

func deselect_anim() -> void:
	anim.play("deselect")

func score() -> void:
	push_error("No score function!")

func add_points(amt : int) -> void:
	arena.add_points(is_player, amt)
