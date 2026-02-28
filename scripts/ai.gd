extends Node


func pick_card(level, opphandcards, oppcardsplayed, playercardsplayed, is_player_first) -> Card:
	if false:
		print("ai thoughts")
		print("opp cards")
		for c in opphandcards:
			print("    ", c.card_name)
		print("opp cards played")
		for c in oppcardsplayed:
			print("    ", c.card_name)
		print("player cards played")
		for c in playercardsplayed:
			print("    ", c.card_name)
		print("player leads", is_player_first)
	#"common": ["plus1", "plus2", "minus2", "times2", "minus2other"],
	#"rare" : ["swap", "destroy", "nothing", "block"],
	#"legendary" : ["plusround", "addround", "invert"]
	if level == 0:
		return opphandcards.pick_random()
	elif level == 1:
		# Try to play plus and times and minues to other cards
		for c in opphandcards:
			if c.card_name == "plus1" or \
				c.card_name == "plus2" or \
				c.card_name == "times2" or \
				c.card_name == "minus2other":
					return c
		
		# Try not to play minus, inverse, or swap cards 
		var try_to_play = []
		for i in range(opphandcards.size()):
			var c = opphandcards[i].card_name
			if c == "minus2" or \
				c == "invert" or \
				c == "swap":
					continue
			try_to_play.append(i)
			
		if len(try_to_play) > 0:
			return opphandcards[try_to_play.pick_random()]
		else:
			return opphandcards.pick_random()
		
	else:
		# Random
		return opphandcards.pick_random()
