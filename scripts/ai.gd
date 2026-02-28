extends Node


func pick_card(level, opphandcards, oppcardsplayed, playercardsplayed, is_player_first) -> Card:
	#print("opp cards")
	#for c in opphandcards:
	#	print("    ", c.card_name)
	#print("opp cards played")
	#for c in oppcardsplayed:
	#	print("    ", c.card_name)
	#print("player cards played")
	#for c in playercardsplayed:
	#	print("    ", c.card_name)
	#print("player leads", is_player_first)
	if level == 0:
		return opphandcards.pick_random()
	elif level == 1:
		return opphandcards.pick_random()
	else:
		return opphandcards.pick_random()
