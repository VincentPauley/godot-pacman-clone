extends Node2D

@export var pellet_scene: PackedScene # < reference pellet.tscn in inspector
@export var player: PackedScene

@onready var HUD = %HUD
@onready var level_layout = %LevelLayout

var score = 0

func _ready() -> void:
	var tiles_by_type = get_tiles_by_type()
	
	_place_pellet_scenes(tiles_by_type['pellet_cells'])
	_place_player_at_start(tiles_by_type['player_start_cells'][0])

# place tiles on appropriate cells and remove placeholders
func _place_pellet_scenes(pellet_cells: Array[Vector2i]) -> void:
	for pellet_cell in pellet_cells:
		var pellet_scene_insert = pellet_scene.instantiate()
		pellet_scene_insert.position = level_layout.map_to_local(pellet_cell)
		level_layout.erase_cell(pellet_cell)
		add_child(pellet_scene_insert)
	
# expect single player start cell and place a player on it
func _place_player_at_start(start_cell: Vector2i) -> void:
	var dynamic_player = player.instantiate()
	dynamic_player.position = level_layout.map_to_local(start_cell)
	level_layout.erase_cell(start_cell)
	add_child(dynamic_player)

# TODO: project followup: ask if this is typical architecture or not
# comb layout and distribute all attributes accordingly
func get_tiles_by_type() -> Dictionary:
	var pellet_cells: Array[Vector2i] = []
	var player_start_cells: Array[Vector2i] = []
	
	for cell in level_layout.get_used_cells():
		var tile_data = level_layout.get_cell_tile_data(cell)
		
		if tile_data and tile_data.get_custom_data("pellet"):
			pellet_cells.append(cell)
			
		if tile_data and tile_data.get_custom_data("player_start"):
			player_start_cells.append(cell)
			
	return { "pellet_cells": pellet_cells, "player_start_cells": player_start_cells }

func handle_pellet_pickup() -> void:
	score += 10
	HUD.update_score(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
