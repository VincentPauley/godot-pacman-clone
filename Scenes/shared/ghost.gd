extends Character

# This class controls what the enemies and player have in common, the way they
# are allowed to move within the level restricted by walls.

var SPEED = 20

var current_direction: Direction = Direction.LEFT
var movement_allowed = true

func _ready() -> void:
	super.init_current_tile(global_position)
	super.set_target_tile(current_direction)
	

func _physics_process(delta: float) -> void:
	

	if (global_position.distance_to(target_tile_center) < 1):
		print('update')
		_reset_tiles(current_direction)
		print("Current Tile: ", current_tile)
		print("Target Tile: ", target_tile)
#		up next: check if target tile is available, if not allow no movement,
#		ghost shold stop when it runs into a wall tile.

	if (movement_allowed):
		var movement_vector = Vector2(DIRECTION_VECTORS[current_direction])
		global_position += movement_vector * SPEED * delta
	
	
	# when a new target tile is set we need to update the center of it so that we can tell
	# when ghost is close to hitting it.
	
#	this is a little different than player because we don't need to buffer the
# player's input to feel responsive instead just find a junction and determine a 
# change in direction

	move_and_slide()
