extends Node

@export var persona_name : Label
@export var player_name : LineEdit
@export var error_label : Label
@export var host : Button
@export var address : LineEdit
@export var lobby_container : ItemList
@export var steam_connect : Control
@export var steam_players : Control

@export var enet_address_entry : LineEdit
@export var enet_start_button : Button

@onready var lobby_name: ItemList = %LobbyName
@onready var players: ItemList = %Players
@onready var id: ItemList = %ID
@onready var lobby_id: LineEdit  = %LobbyId

signal game_log(what : String)

func _ready():
	persona_name.text = Steam.getPersonaName()
	
	# Called every time the node is added to the scene.
	gamestate.connection_failed.connect(self._on_connection_failed)
	gamestate.connection_succeeded.connect(self._on_connection_success)
	gamestate.player_list_changed.connect(self.refresh_lobby)
	gamestate.game_ended.connect(self._on_game_ended)
	gamestate.game_error.connect(self._on_game_error)
	gamestate.game_log.connect(self._on_game_log)
	player_name.text = Steam.getPersonaName() # Set player name to Steam username.
	game_log.connect(self._on_game_log)
	
	#if OS.has_feature("server"):
		#gamestate.create_enet_host(player_name.text)
		#gamestate.host_lobby(player_name.text)
		#gamestate.begin_game()
		#return
	_setup_ui()

func _setup_ui():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_CLOSE)
	Steam.lobby_match_list.connect(fill_loby_menu)
	_request_lobby_list()

func fill_loby_menu(lobbies : Array):
	for sample in lobbies:
		if ( lobby_id.text != "" &&
			!(str(sample).contains(lobby_id.text) ||
			  str(Steam.getLobbyData(sample, "name")).contains(lobby_id.text))
		):
			return
		lobby_name.add_item(" "+Steam.getLobbyData(sample, "name"))
		players.add_item(" "+str(Steam.getNumLobbyMembers(sample)),null, false)
		id.add_item(str(sample),null,false)

func _request_lobby_list():
	Steam.addRequestLobbyListStringFilter("game", gamestate.GAME_ID, Steam.LOBBY_COMPARISON_EQUAL)

	lobby_name.clear()
	players.clear()
	id.clear()
	
	Steam.requestLobbyList()

func _on_host_pressed():
	steam_connect.hide()
	steam_players.show()
	gamestate.host_lobby(player_name.text)
	refresh_lobby()

func _on_connection_success():
	steam_connect.hide()
	steam_players.show()

func _on_connection_failed():
	host.disabled = false
	error_label.set_text("Connection failed.")

func _on_game_ended():
	show()
	steam_connect.show()
	steam_players.hide()
	host.disabled = false

func _on_game_error(errtxt : String):
	$ErrorDialog.dialog_text = errtxt
	$ErrorDialog.popup_centered()
	host.disabled = false

func _on_game_log(logtxt : String):
	print(logtxt)

func refresh_lobby():
	var players_list = gamestate.players.values()
	players_list.sort()
	%SteamList.clear()
	for sample_name in players_list:
		%SteamList.add_item(
			sample_name if 
				sample_name != gamestate.player_name else 
				(sample_name + " (You)")
		)
	
	%SteamStart.disabled = not multiplayer.is_server()
	await Steam.lobby_joined #Ensure we have an actual lobby ID before continuing
	%SteamLobbyID.text = str(gamestate.lobby_id)
	_request_lobby_list()
	
func _on_start_pressed():
	gamestate.begin_game()

func _on_enet_host_pressed():
	gamestate.create_enet_host(player_name.text)
	enet_start_button.disabled = false #Issue: player isn't being added to `players` list

func _on_enet_join_pressed():
	gamestate.player_name = player_name.text
	gamestate.create_enet_client(
		gamestate.player_name,
		"127.0.0.1" if enet_address_entry.text.is_empty()
		else enet_address_entry.text)

func _on_lobby_name_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	%Connect.hide()
	$TabContainer/Steam/Players.show()
	gamestate.join_lobby(
		int(%ID.get_item_text(index)),
		player_name.text)

func _on_join_pressed() -> void:
	if lobby_name.get_selected_items().is_empty():
		return
	var index:int =	lobby_name.get_selected_items()[0]
	steam_connect.hide()
	steam_players.show()
	gamestate.join_lobby(int(id.get_item_text(index)), gamestate.player_name)

func _on_back_pressed() -> void:
	gamestate.end_game()

func _on_lobby_id_text_submitted(_new_text: String) -> void:
	_request_lobby_list()
	
func _on_id_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	DisplayServer.clipboard_set(%ID.get_item_text(index))

func _on_lobby_name_item_activated(_index: int) -> void:
	_on_join_pressed()

func _on_steam_kick_pressed() -> void:
	gamestate.game_error.emit("Server disconnected")
	gamestate.end_game()

func _on_lobby_id_text_changed(_new_text: String) -> void:
	_request_lobby_list()
	
func failed_to_connect(response):
	var FAIL_REASON: String
	match response:
		Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST:
			FAIL_REASON = "This lobby no longer exists."
		Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED:
			FAIL_REASON = "You don't have permission to join this lobby."
		Steam.CHAT_ROOM_ENTER_RESPONSE_FULL:
			FAIL_REASON = "The lobby is now full."
		Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR:
			FAIL_REASON = "Uh... something unexpected happened!"
		Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED:
			FAIL_REASON = "You are banned from this lobby."
		Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED:
			FAIL_REASON = "You cannot join due to having a limited account."
		Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED:
			FAIL_REASON = "This lobby is locked or disabled."
		Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN:
			FAIL_REASON = "This lobby is community locked."
		Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU:
			FAIL_REASON = "A user in the lobby has blocked you from joining."
		Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER:
			FAIL_REASON = "A user you have blocked is in the lobby."
	print(FAIL_REASON)

const DEFAULT_PORT = 10567
const MAX_PEERS = 12
const GAME_ID = "xcNhLTRbBH"

var peer: MultiplayerPeer = null
var player_name: String
var players := {}
var players_ready := []
var lobby_id := -1

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what: String)
signal game_log(what: String)

func _ready():
	Steam.steamInitEx(true, 480)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.lobby_created.connect(_on_lobby_created)

func _process(_delta: float):
	Steam.run_callbacks()

@rpc("call_local", "any_peer")
func register_player(new_player_name: String):
	var id = multiplayer.get_remote_sender_id()
	players[id] = _make_string_unique(new_player_name)
	player_list_changed.emit()

func unregister_player(id):
	players.erase(id)
	player_list_changed.emit()

@rpc("call_local")
func load_world():
	var world = load("res://world.tscn").instantiate()
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").hide()
	get_tree().set_pause(false)

func host_lobby(new_player_name: String):
	player_name = new_player_name
	players[1] = new_player_name
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, MAX_PEERS)

func join_lobby(new_lobby_id: int, new_player_name: String):
	player_name = new_player_name
	Steam.joinLobby(new_lobby_id)

func begin_game():
	assert(multiplayer.is_server())
	load_world.rpc()
	for peer_id in players:
		var pame = players[peer_id]
		spawn_player.rpc(peer_id, Vector3.ZERO, pame)

@rpc("any_peer", "call_local")
func spawn_player(id: int, position: Vector3, new_name: String):
	var player_scene = preload("res://scenes/Player/player.tscn")
	var player = player_scene.instantiate()
	player.name = str(id)
	print(id)
	player.position = position
	player.set_player_name(new_name)
	get_tree().get_root().get_node("World/Players").add_child(player)
	player.set_multiplayer_authority(id)

func create_steam_socket():
	peer = SteamMultiplayerPeer.new()
	peer.create_host(0, [])
	if peer:
		multiplayer.multiplayer_peer = peer

func connect_steam_socket(steam_id: int):
	peer = SteamMultiplayerPeer.new()
	peer.create_client(steam_id, 0, [])
	multiplayer.multiplayer_peer = peer

func create_enet_host(new_player_name: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_server(DEFAULT_PORT)
	player_name = new_player_name
	players[1] = new_player_name
	multiplayer.multiplayer_peer = peer

func create_enet_client(new_player_name: String, address: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, DEFAULT_PORT)
	multiplayer.multiplayer_peer = peer
	await multiplayer.connected_to_server
	register_player.rpc(new_player_name)
	players[multiplayer.get_unique_id()] = new_player_name

func _make_string_unique(query: String) -> String:
	var count := 2
	var trial := query
	while players.values().has(trial):
		trial = query + ' ' + str(count)
		count += 1
	return trial

@rpc("call_local", "any_peer")
func get_player_name() -> String:
	return players[multiplayer.get_remote_sender_id()]

func is_game_in_progress() -> bool:
	return has_node("/root/World")

func end_game():
	if is_game_in_progress():
		get_node("/root/World").queue_free()
	game_ended.emit()
	players.clear()

func _on_peer_connected(id: int):
	register_player.rpc_id(id, player_name)

func _on_peer_disconnected(id: int):
	if is_game_in_progress():
		if multiplayer.is_server():
			game_error.emit("Player " + players[id] + " disconnected")
			end_game()
	else:
		unregister_player(id)

func _on_connected_to_server():
	connection_succeeded.emit()

func _on_connection_failed():
	multiplayer.multiplayer_peer = null
	connection_failed.emit()

func _on_server_disconnected():
	game_error.emit("Server disconnected")
	end_game()

func _on_lobby_joined(new_lobby_id: int, _permissions: int, _locked: bool, response: int):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobby_id = new_lobby_id
		var id = Steam.getLobbyOwner(new_lobby_id)
		if id != Steam.getSteamID():
			connect_steam_socket(id)
			register_player.rpc(player_name)
			players[multiplayer.get_unique_id()] = player_name
	else:
		var FAIL_REASON: String
		match response:
			Steam.CHAT_ROOM_ENTER_RESPONSE_DOESNT_EXIST:
				FAIL_REASON = "This lobby no longer exists."
			Steam.CHAT_ROOM_ENTER_RESPONSE_NOT_ALLOWED:
				FAIL_REASON = "You don't have permission to join this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_FULL:
				FAIL_REASON = "The lobby is now full."
			Steam.CHAT_ROOM_ENTER_RESPONSE_ERROR:
				FAIL_REASON = "Uh... something unexpected happened!"
			Steam.CHAT_ROOM_ENTER_RESPONSE_BANNED:
				FAIL_REASON = "You are banned from this lobby."
			Steam.CHAT_ROOM_ENTER_RESPONSE_LIMITED:
				FAIL_REASON = "You cannot join due to having a limited account."
			Steam.CHAT_ROOM_ENTER_RESPONSE_CLAN_DISABLED:
				FAIL_REASON = "This lobby is locked or disabled."
			Steam.CHAT_ROOM_ENTER_RESPONSE_COMMUNITY_BAN:
				FAIL_REASON = "This lobby is community locked."
			Steam.CHAT_ROOM_ENTER_RESPONSE_MEMBER_BLOCKED_YOU:
				FAIL_REASON = "A user in the lobby has blocked you from joining."
			Steam.CHAT_ROOM_ENTER_RESPONSE_YOU_BLOCKED_MEMBER:
				FAIL_REASON = "A user you have blocked is in the lobby."
		game_log.emit(FAIL_REASON)

func _on_lobby_created(status: int, new_lobby_id: int):
	if status == 1:
		Steam.setLobbyData(new_lobby_id, "name", Steam.getPersonaName() + "'s Fantasy Server")
		Steam.setLobbyData(new_lobby_id, "game", GAME_ID)
		create_steam_socket()
	else:
		game_error.emit("Error on create lobby!")
