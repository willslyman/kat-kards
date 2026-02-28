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
	
	if !selected and arena.current_cards_selected == arena.card_play_size:
		base.block_select()
		return
	
	if !selected:
		arena.current_cards_selected += 1
		base.select()
	else:
		arena.current_cards_selected -= 1
		base.deselect()
	selected = !selected

func deselect_anim() -> void:
	base.deselect()

func use() -> void:
	base.use()
	await base.animation_player.animation_finished
	await score()
	
func un_use() -> void:
	base.un_use()

func score() -> void:
	push_error("No score function!")

func add_points(amt : int) -> void:
	arena.add_points(is_player, amt)

func add_mult(mlt : float) -> void:
	arena.add_mult(is_player, mlt)
