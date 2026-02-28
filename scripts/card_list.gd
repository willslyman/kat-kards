extends Node

const categories = ["common", "rare", "legendary"]
const categorie_weights = [10, 3, 1]

var rng = null

var card_list = {
	"nothing" : preload("uid://bh2li4s4vl4vx"),
	"swap" : preload("uid://bc4vlcs44b3bl"),
	"plus1" : preload("uid://ce855u7bi6ev1"),
	"plus2" : preload("uid://gfjx2q1emkgw"),
	"minus2" : preload("uid://bq1hl73ql6uhb"),
	"times2" : preload("uid://bmtbradsvsyas"), 
	"timesround" : preload("uid://bk7ova61wxi4v"),
	"addround" : preload("uid://4gq5f7rcktu7"),
	"invert" : preload("uid://cmkpfod0jqjbn"),
	"destroy" : preload("uid://g5wl5jd84fb7")
}

var card_categories = {
	"common": ["plus1", "plus2", "minus2", "times2"],
	"rare" : ["swap", "destroy", "nothing"],
	"legendary" : ["timesround", "addround", "invert"]
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
	preload("uid://d0causlxcmxaa"),
	preload("uid://c2uh3ur5kigcb")
]

var card_to_texture = {}

var seen_cards : Array[String] = []
var card_thoughts : Dictionary = {}

func _ready() -> void:
	rng = RandomNumberGenerator.new()

func get_a_card() -> String:
	var category = categories[rng.rand_weighted(categorie_weights)]
	
	var possible = card_categories[category]
	
	return possible.pick_random()

func assign_textures() -> void:
	card_textures.shuffle()
	
	var i : int = 0
	for card in card_list.keys():
		card_to_texture[card] = card_textures[i]
		card_thoughts[card] = ""
		i += 1
