extends CharacterBody2D


@export var tile_layout: TileMapLayer

const SPEED = 15.0

enum Direction { NONE, UP, DOWN, LEFT, RIGHT }

var current_direction: Direction = Direction.LEFT
var queued_direction: Direction = Direction.NONE

# Pac-Man cannot move in diagonals, only one direction at a time, setting up
# directions this way rather than allows finite control for that
const DIRECTION_VECTORS = {
	Direction.UP: Vector2i(0, -1),
	Direction.DOWN: Vector2i(0, 1),
	Direction.LEFT: Vector2i(-1, 0),
	Direction.RIGHT: Vector2i(1, 0)
}

var direction = Vector2i(-1, 0)

func _ready() -> void:
	pass

	
	
# use the tilemap and player's local position to determine the tile they are currently over
func _get_current_tile() -> Vector2i:
	return tile_layout.local_to_map(tile_layout.to_local(global_position))

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
		
		# set current direction
		if player_direction_input == 'player_down':
			current_direction = Direction.DOWN
		elif player_direction_input == 'player_up':
			current_direction = Direction.UP
		elif player_direction_input == 'player_right':
			current_direction = Direction.RIGHT
		elif player_direction_input == 'player_left':
			current_direction = Direction.LEFT
	
	if current_direction != Direction.NONE:
		var movement_vector = Vector2(DIRECTION_VECTORS[current_direction])
		global_position += movement_vector * SPEED * delta
		
	var current_cell = _get_current_tile()
	
	print("current cell:")
	print(current_cell)
	
	var target_cell: Vector2i = current_cell + DIRECTION_VECTORS[current_direction]
	
	print("target cell:")
	print(target_cell)
		
	move_and_slide()
