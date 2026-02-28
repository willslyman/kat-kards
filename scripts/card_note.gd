extends Control

var card_name : String = ""

func setup(cn : String) -> void:
	card_name = cn
	$TextureRect.texture = CardList.card_to_texture[card_name]
	$LineEdit.text = CardList.card_thoughts[card_name]

func save() -> void:
	CardList.card_thoughts[card_name] = $LineEdit.text
