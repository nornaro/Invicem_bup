extends HBoxContainer
#
##@rpc("any_peer", "call_local")
##func increase_score(for_who : int):
	##var txt = ""
	##assert(for_who in Autoload.player_labels)
	##var pl = Autoload.player_labels[for_who]
	##pl.score += 1
	##pl = Autoload.player_labels[for_who]
	##txt += (pl.name + ": " + str(pl.score) + "\n")
	##pl.label.text = txt
	##
	##print(Autoload.player_labels)
#
#@rpc("any_peer", "call_local")
#func increase_score(for_who: int):
	#var txt = ""
	#assert(for_who in Autoload.player_labels)
	#var pl = Autoload.player_labels[for_who]
	#pl.score += 1
	#txt += (pl.name + ": " + str(pl.score) + "\n")
	#pl.label.text = txt
#
	## Update the player label in the Autoload list
	#Autoload.player_labels[for_who] = pl
	#
	## Broadcast the updated player labels to all clients
	#rpc("update_player_labels", Autoload.player_labels)
#
#@rpc("any_peer", "call_local")
#func update_player_labels(new_labels: Array):
	#Autoload.player_labels = new_labels
	#print(Autoload.player_labels)
#
#
#@rpc("any_peer", "call_local")
#func set_player_name(value: String):
	#if not Autoload.player_labels.has(value):
		#Autoload.player_labels.append(value)
		#rpc("update_player_labels", Autoload.player_labels)
#
	#
#func set_score():
	#for for_who in Autoload.player_labels.keys:
		#var _pl = Autoload.player_labels[for_who]
#
#
#func add_player(id, new_player_name):
	#var l = Label.new()
	#l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#l.set_text(new_player_name + "\n" + "0")
	#l.set_h_size_flags(SIZE_EXPAND_FILL)
	#var font = preload("res://montserrat.otf")
	#l.set("custom_fonts/font", font)
	#l.set("custom_font_size/font_size", 18)
	#add_child(l)
#
	#Autoload.player_labels[id] = { name = new_player_name, label = l, score = 0, id = id }
	#print(Autoload.player_labels[id])
#
#
#func _ready():
	#for player in gamestate.players:
		##TODO: Does not seem to be called for client?
		#add_player(player, gamestate.players[player])
	#$"../Winner".hide()
	#set_process(true)
#
#
#func _on_exit_game_pressed():
	#gamestate.end_game()
