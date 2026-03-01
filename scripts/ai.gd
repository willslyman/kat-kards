extends Node

func basic_ai(opphandcards) -> Card:
	# Try to play plus and times and minues to other cards
	for c in opphandcards:
		if c.card_name == "plus1" or \
			c.card_name == "plus2" or \
			c.card_name == "times2" or \
			c.card_name == "minus2other" or \
			c.card_name == "addround":
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


func pick_card(level, opphandcards, oppcardsplayed, playercardsplayed, is_player_first, round) -> Card:
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
		# Random
		return opphandcards.pick_random()
	elif level == 1:
		return basic_ai(opphandcards)
	else:
		# get some info about setup
		var has_invert_or_swap = false
		var block = null
		var destroy = null
		
		## Should we play swap or invert
		for c in opphandcards:
			if c.card_name == "invert" or \
				c.card_name == "swap":
				has_invert_or_swap = true
			elif c.card_name == "block":
				block = c
			elif c.card_name == "destroy":
				destroy = c
				
		## Block swap and invert if can
		if is_player_first and \
			(playercardsplayed.back().card_name == "invert" or playercardsplayed.back().card_name == "swap"):
			if block != null:
				return block
		
		## Destroy swap or invert if can
		if not is_player_first and \
			playercardsplayed.size() > 0 and \
			(playercardsplayed[0].card_name == "invert" or playercardsplayed[0].card_name == "swap"):
			if destroy != null:
				return destroy
		
		var end_score_guess = 0
		
		for c in oppcardsplayed:
			if c.card_name == "plus1":
				end_score_guess += 1
			elif c.card_name == "plus2":
				end_score_guess += 2
			elif c.card_name == "minus2":
				end_score_guess -= 2
			elif c.card_name == "addround":
				end_score_guess += round
		
		for c in playercardsplayed:
			if c.card_name == "minus2other":
				end_score_guess -= 2

		if end_score_guess < 0 and has_invert_or_swap:
			for c in opphandcards:
				if c.card_name == "invert" or \
					c.card_name == "swap":
					return c
		
		## If we have minus2 and swap or invert, play minus2
		for c in opphandcards:
			if c.card_name == "minus2" and has_invert_or_swap:
				return c
				
		## Basic heristics to follow
		return basic_ai(opphandcards)
