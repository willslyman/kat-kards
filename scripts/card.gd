extends Area2D
class_name Card

@export var card_name = ""

var arena : Arena
var is_player : bool = false

var selected : bool = false
var playing : bool = false
@onready var base: CardBase = $CardBase

var in_use : bool = false

var destroyed : bool = false

var block : bool = false

func get_blocked():
	base.get_blocked()

func setup(a : Arena, ip : bool) -> void:
	arena = a
	is_player = ip
	
	base.set_texture(CardList.card_to_texture[card_name])
	
	on_create()

func hover() -> void:
	base.hover()

func unhover() -> void:
	base.unhover()

func select() -> void:
	if playing or selected or arena.can_not_select() or !is_player:
		return
	
	selected = true
	arena.select_card(self)

func deselect_anim() -> void:
	base.unhover()

func use() -> void:
	in_use = true
	base.use()
	#print(card_name)
	await base.animation_player.animation_finished
	await score()
	
func un_use() -> void:
	base.un_use()
	in_use = false

func score() -> void:
	push_error("No score function!")
	
func on_create() -> void:
	pass

func add_points(amt : int, to_other = false) -> void:
	if to_other:
		arena.add_points(not is_player, amt)
	else:
		arena.add_points(is_player, amt)

func add_mult(mlt : float) -> void:
	arena.add_mult(is_player, mlt)

func current_round() -> int:
	return arena.current_round
	
func destroy() -> void:
	destroyed = true
	
	# Can't block if destroyed
	block = false
	self.visible = false

func destroy_other_card() -> void:
	if is_player:
		arena.destroy_opp_card()
	else: 
		arena.destroy_player_card()
	
func swap_cards() -> void:
	arena.swap_cards()

func add_round() -> void:
	arena.current_max_rounds += 1
