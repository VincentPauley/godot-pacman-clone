extends CharacterBody2D


@export var tile_layout: TileMapLayer

const SPEED = 200.0

enum Direction { NONE, UP, DOWN, LEFT, RIGHT }

var current_direction: Direction = Direction.LEFT
var queued_direction: Direction = Direction.NONE

var movement_enabled: bool = true

# Pac-Man cannot move in diagonals, only one direction at a time, setting up
# directions this way rather than allows finite control for that
const DIRECTION_VECTORS = {
	Direction.UP: Vector2i(0, -1),
	Direction.DOWN: Vector2i(0, 1),
	Direction.LEFT: Vector2i(-1, 0),
	Direction.RIGHT: Vector2i(1, 0)
}

var direction = Vector2i(-1, 0)

var current_tile: Vector2i
var target_tile: Vector2i
var target_tile_center: Vector2

func _ready() -> void:
	current_tile = _get_current_tile()
	target_tile = _get_next_tile()
	target_tile_center = _get_tile_center(target_tile)
	_check_movement_disabled()
	
# this should use the direction to determine what the next tile is
func _get_next_tile() -> Vector2i:
	return current_tile + DIRECTION_VECTORS[current_direction]

# world-space position of the center of the given tile cell
func _get_tile_center(cell: Vector2i) -> Vector2:
	return tile_layout.to_global(tile_layout.map_to_local(cell))

# use the tilemap and player's position (by origin) to determine the tile they are currently over
func _get_current_tile() -> Vector2i:
	return tile_layout.local_to_map(tile_layout.to_local(global_position))

func _check_movement_disabled() -> void:
	var target_tile_data = tile_layout.get_cell_tile_data(target_tile)
	
	if (target_tile_data):
		var targeting_wall = target_tile_data.get_custom_data("wall")
		if (targeting_wall):
			movement_enabled = false
		else:
			movement_enabled = true
	else:
		movement_enabled = true
		
func _check_to_update_target_tile() -> void:
	target_tile = _get_next_tile()
	target_tile_center = _get_tile_center(target_tile)
	_check_movement_disabled()
	
# true if the tile adjacent to current_tile in the given direction is open (not a wall)
func _is_direction_open(dir: Direction) -> bool:
	var cell = current_tile + DIRECTION_VECTORS[dir]
	var cell_data = tile_layout.get_cell_tile_data(cell)
	return not (cell_data and cell_data.get_custom_data("wall"))

# switch to the queued direction if it's open from current_tile, and refresh the target tile
func _try_commit_queued_direction() -> void:
	if queued_direction != Direction.NONE and queued_direction != current_direction and _is_direction_open(queued_direction):
		current_direction = queued_direction
		target_tile = _get_next_tile()
		target_tile_center = _get_tile_center(target_tile)
		_check_movement_disabled()

func _run_tile_movement_check() -> void:
	# player is close enough to next tile center, move them to exact center
	global_position = _get_tile_center(target_tile)

	# player has reached the target tile, it now becomes current tile
	current_tile = target_tile

	# prefer the queued direction if it's now open, otherwise keep going straight
	_try_commit_queued_direction()

	target_tile = _get_next_tile()
	target_tile_center = _get_tile_center(target_tile)
	_check_movement_disabled()

var input_stack: Array[String] = []
# this is a really cool solution that forces only the most recently entered input
# for direction to be the one used, no conflict or combinations possible.	
func _process_input_direction() -> void:
	var direction_actions = ["player_down", "player_up", "player_right", "player_left"]

	for dir in direction_actions:
		if Input.is_action_pressed(dir):
			input_stack.erase(dir) # prevent duplicates
			input_stack.append(dir)
		elif Input.is_action_just_released(dir):
			input_stack.erase(dir) # remove when released
			
	
func _physics_process(delta: float) -> void:
	_process_input_direction()
	
	if input_stack.size():
		var player_direction_input = input_stack.back()
		
		# only record the desired direction here; actual travel direction is
		# committed in _run_tile_movement_check once a tile center is reached
		if player_direction_input == 'player_down':
			queued_direction = Direction.DOWN
		elif player_direction_input == 'player_up':
			queued_direction = Direction.UP
		elif player_direction_input == 'player_right':
			queued_direction = Direction.RIGHT
		elif player_direction_input == 'player_left':
			queued_direction = Direction.LEFT

	# when player gets really close to the center of target tile move them to it
	# exactly and block movement if the new target is a wall
	if (global_position.distance_to(target_tile_center) < 1):
		_run_tile_movement_check()
	elif not movement_enabled:
		# stopped at a wall; allow turning away without waiting to reach a tile center
		_try_commit_queued_direction()
	
	if current_direction != Direction.NONE and movement_enabled:
		var movement_vector = Vector2(DIRECTION_VECTORS[current_direction])
		global_position += movement_vector * SPEED * delta
		
	
	move_and_slide()
