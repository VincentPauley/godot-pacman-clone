extends Node2D

@export var pellet_scene: PackedScene # < reference pellet.tscn in inspector
@export var player: PackedScene

@onready var pellet_marker_tiles = %PelletMarkers

func _ready() -> void:

	for cell in pellet_marker_tiles.get_used_cells():
		var pellet_insert = pellet_scene.instantiate()
		pellet_insert.position = pellet_marker_tiles.map_to_local(cell)
		add_child(pellet_insert)
		print(cell)
		
	# no need to show the actual markers
	pellet_marker_tiles.visible = false
	
	# add player to scene like so
	var dynamic_player = player.instantiate()
	add_child(dynamic_player)
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
