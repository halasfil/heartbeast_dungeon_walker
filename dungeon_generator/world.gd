extends Node

#loading nodes
const PLAYER = preload("res://player.tscn")
const Exit = preload("res://exitdoor.tscn")
@onready var tilemap = $TileMap
#borders of our tilemap max reach
var borders = Rect2(1, 1, 80, 40)

func _ready():
	generate_level()
	
func generate_level():
	#instantiating walker
	var walker = Walker.new(Vector2(20, 11), borders)
	#we want to walk for 500 steps to generate the map
	var map = walker.walk(1000)
	#deleting walker after the walk
	walker.queue_free()
	
	#instantiate player and put him after first step. each step is 32units
	var player = PLAYER.instantiate()
	add_child(player)
	player.position = map.front()*32
	
	var exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position*32
	exit.connect("leaving_level", Callable(self, "reload_level"))
	
	#(layer: int, cells: Array[Vector2i], terrain_set: int, terrain: int, ignore_empty_terrains: bool = true)
	#0 - layer we are working on
	#map - our map that walker has created
	#0 - our terrain_set (check tyleset - which one we are using)
	#0 - our terrain (check tyleset again - which one we are using)
	#false - we don't want to ignore empty terrains when creating the map
	tilemap.set_cells_terrain_connect(0, map, 0, 0, true)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()

func reload_level():
	get_tree().reload_current_scene()
