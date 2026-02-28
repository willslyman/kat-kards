extends Area2D
class_name Card

@export var card_name = ""

var arena : Arena
var is_player : bool = false

var selected : bool = false
var playing : bool = false
@onready var base: CardBase = $CardBase

func setup(a : Arena, ip : bool) -> void:
	arena = a
	is_player = ip
	
	base.set_texture(CardList.card_to_texture[card_name])

func select() -> void:
	if playing: return
	
	if !selected:
		base.select()
	else:
		base.deselect()
	selected = !selected

func deselect_anim() -> void:
	base.deselect()

func score() -> void:
	push_error("No score function!")

func add_points(amt : int) -> void:
	arena.add_points(is_player, amt)
