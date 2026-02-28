extends Node

var card_list = {
	"swap" : preload("uid://bc4vlcs44b3bl"),
	"plus1" : preload("uid://ce855u7bi6ev1"),
	"plus2" : preload("uid://gfjx2q1emkgw"),
	"times2" : preload("uid://bmtbradsvsyas"), 
	"destroy" : preload("uid://g5wl5jd84fb7")
}

var card_textures = [
	preload("uid://bjq04w1g5i6ux"),
	preload("uid://1si8ety7k0bx"),
	preload("uid://cpf6gxsmk6fo5"),
	preload("uid://b62d2ipf820vo"),
	preload("uid://bmjol6vl4j7l7"),
	preload("uid://birmcdetu2lug"),
	preload("uid://cf1cb3pf31wmb"),
	preload("uid://cob24bfvkyht5"),
	preload("uid://d0causlxcmxaa")
]

var card_to_texture = {}

var seen_cards : Array[String] = []
var card_thoughts : Dictionary = {}

func assign_textures() -> void:
	card_textures.shuffle()
	
	var i : int = 0
	for card in card_list.keys():
		card_to_texture[card] = card_textures[i]
		card_thoughts[card] = ""
		i += 1
