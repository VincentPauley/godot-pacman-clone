extends Character

# This class controls what the enemies and player have in common, the way they
# are allowed to move within the level restricted by walls.

var SPEED = 75

var current_direction: Direction = Direction.LEFT
var movement_allowed = true

func _ready() -> void:
	super.init_current_tile(global_position)
	super.set_target_tile(current_direction)
	
func _find_new_direction() -> Direction:
	print("Direction.UP: ", Direction.UP) # 1
	print("Direction.DOWN: ", Direction.DOWN ) # 2
	print("Direction.LEFT: ", Direction.LEFT ) # 3
	print("Direction.RIGHT: ", Direction.RIGHT ) # 4
	
	if (current_direction == Direction.LEFT):
		return [Direction.DOWN, Direction.UP].pick_random()
	print("current_direction: ", current_direction)
	return current_direction
	

func _physics_process(delta: float) -> void:
	

	if (global_position.distance_to(target_tile_center) < 3):
		# align player to target tile center to avoid drift issues
		global_position = target_tile_center
		_reset_tiles(current_direction)
		
		#print('update')
		#print("Current Tile: ", current_tile)
		#print("Target Tile: ", target_tile)
		
		var target_available = super.check_tile_available(target_tile)

		if (!target_available):
			movement_allowed = false
			
			print('had to stop')
			var new_direction = _find_new_direction()
			
			current_direction = new_direction
			movement_allowed = true


	if (movement_allowed):
		var movement_vector = Vector2(DIRECTION_VECTORS[current_direction])
		global_position += movement_vector * SPEED * delta
	

	
#	this is a little different than player because we don't need to buffer the
# player's input to feel responsive instead just find a junction and determine a 
# change in direction

	move_and_slide()
