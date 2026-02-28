extends Control

const CARD_NOTE = preload("uid://b660xuu1r1kl2")
@onready var grid: GridContainer = $ScrollContainer/GridContainer

signal on_back

func on_show() -> void:
	for card in CardList.card_list:
		if card in CardList.seen_cards:
			var cn = CARD_NOTE.instantiate()
			cn.setup(card)
			grid.add_child(cn)

func on_hide() -> void:
	for card in grid.get_children():
		card.save()
		card.queue_free()

func _on_button_pressed() -> void:
	on_back.emit()
