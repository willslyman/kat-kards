extends Control
class_name Notepad

const CARD_NOTE = preload("uid://b660xuu1r1kl2")
@onready var grid: GridContainer = $ScrollContainer/GridContainer

var open : bool = false
signal on_back

func on_show() -> void:
	open = true
	for card in CardList.card_list:
		if card in CardList.seen_cards:
		#if true:
			var cn = CARD_NOTE.instantiate()
			cn.setup(card)
			grid.add_child(cn)

func on_hide() -> void:
	for card in grid.get_children():
		card.save()
		card.queue_free()

func _on_button_pressed() -> void:
	open = false
	on_back.emit()
