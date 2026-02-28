extends Node

var card_list = {
	"plus1" : preload("uid://ce855u7bi6ev1")
}

var card_textures = [
	preload("uid://bjq04w1g5i6ux"),
	preload("uid://1si8ety7k0bx"),
	preload("uid://cpf6gxsmk6fo5"),
	preload("uid://b62d2ipf820vo"),
	preload("uid://bmjol6vl4j7l7"),
	preload("uid://birmcdetu2lug")
]

var card_to_texture = {}

func assign_textures() -> void:
	card_textures.shuffle()
	
	var i : int = 0
	for card in card_list.keys():
		card_to_texture[card] = card_textures[i]
		i += 1
	
	print(card_to_texture)
