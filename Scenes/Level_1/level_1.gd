extends Node2D

@export var pellet_scene: PackedScene # < reference pellet.tscn in inspector
@export var player: PackedScene

@onready var pellet_marker_tiles = %PelletMarkers
@onready var HUD = %HUD
@onready var level_layout = %LevelLayout

var score = 0

func _ready() -> void:
	var player_start_position = get_player_start_cells()
	
	print(player_start_position)
	for cell in pellet_marker_tiles.get_used_cells():
		var pellet_insert = pellet_scene.instantiate()
		pellet_insert.position = pellet_marker_tiles.map_to_local(cell)
		add_child(pellet_insert)
		
	# no need to show the actual markers
	pellet_marker_tiles.visible = false
	
	# add player to scene like so
	var dynamic_player = player.instantiate()
	
	if player_start_position.size() > 0:
		dynamic_player.position = level_layout.map_to_local(player_start_position[0])
		add_child(dynamic_player)


func get_player_start_cells() -> Array[Vector2i]:
	var start_cells: Array[Vector2i] = []
	for cell in level_layout.get_used_cells():
		var tile_data = level_layout.get_cell_tile_data(cell)
		if tile_data and tile_data.get_custom_data("player_start"):
			start_cells.append(cell)
	return start_cells


func handle_pellet_pickup() -> void:
	score += 10
	HUD.update_score(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
