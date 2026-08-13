extends Node2D

@export var pellet_scene: PackedScene # < reference pellet.tscn in inspector
@export var player: PackedScene

@onready var pellet_marker_tiles = %PelletMarkers
@onready var HUD = %HUD


var score = 0

func _ready() -> void:
	for cell in pellet_marker_tiles.get_used_cells():
		var pellet_insert = pellet_scene.instantiate()
		pellet_insert.position = pellet_marker_tiles.map_to_local(cell)
		add_child(pellet_insert)
		
	# no need to show the actual markers
	pellet_marker_tiles.visible = false
	
	# add player to scene like so
	var dynamic_player = player.instantiate()
	add_child(dynamic_player)


func handle_pellet_pickup() -> void:
	score += 10
	HUD.update_score(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
