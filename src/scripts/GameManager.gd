extends Node

signal pause()
signal unpause()
signal coin_update(value)
signal king_damaged(lives_left)
signal game_start()
signal gameover()

var map_index = 0
var maps = []
var game

var active : bool = false
var lives : int
var coins : int

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	_load_maps()
	game = get_node("/root/Game")
	game.load_map(maps[map_index])

func _input(_input):
	if Input.is_action_just_released("game_pause") and active:
		_toggle_pause()

func new_game():
	lives = 10
	coins = 500
	active = true
	emit_signal("game_start")
	
func next_map():
	map_index = (map_index + 1) % maps.size()
	game.load_map(maps[map_index])
	
func prev_map():
	map_index = (map_index - 1) % maps.size()
	game.load_map(maps[map_index])

func damage_king():
	lives -= 1
	emit_signal("king_damaged", lives)
	if lives <= 0:
		active = false
		emit_signal("gameover")
		
func set_coins(value : int):
	coins = value
	emit_signal("coin_update", value)
		
func get_coins() -> int:
	return coins

func _toggle_pause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		emit_signal("pause")
	else:
		emit_signal("unpause")

func _load_maps():
	var dir = Directory.new()
	dir.open("res://scenes/maps/")
	dir.list_dir_begin(true)
	var map = dir.get_next()
	while map != "":
		var map_ref = load("res://scenes/maps/"+map)
		maps.append(map_ref)
		map = dir.get_next()