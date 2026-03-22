extends Node

const PORT = 9999
var peer = ENetMultiplayerPeer.new()
var player_scene = preload("res://player/Sonic/Sonic.tscn")

var CreateServerFunc = false
var CreateClientFunc = false

func _on_btn_host_pressed() -> void:
	CreateServerFunc = true
	$UI.hide()
	$Level.show()

func _on_btn_join_pressed() -> void:
	CreateClientFunc = true
	$UI.hide()
	$Level.show()

func _process(_delta: float) -> void:
	if CreateServerFunc == true:
		_create_server()
		CreateServerFunc = false
	if CreateClientFunc == true:
		_create_client()
		CreateClientFunc = false

func _create_server():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(
		func(pid):
			print(str(pid))
			_add_player(pid)
	)
	_add_player(multiplayer.get_unique_id())

func _create_client():
	peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = peer

func _add_player(pid):
	var player = player_scene.instantiate()
	player.name = str(pid)
	add_child(player)
	
