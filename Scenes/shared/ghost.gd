extends Character

@onready var level_node = get_parent()

# This class controls what the enemies and player have in common, the way they
# are allowed to move within the level restricted by walls.

var SPEED = 100
var PLAYER_KILLED = false

var current_direction: Direction = Direction.LEFT

func _on_player_killed() -> void:
	#SPEED = 0
	PLAYER_KILLED = true

func _on_collision_shape_entered(collider: Node) -> void:
	if collider.is_in_group("ghosts"):
		return

	if collider is CharacterBody2D:
		print("ghost hit CharacterBody2D: ", collider.name)
		if (collider.name):
			level_node.handle_player_killed()

func _ready() -> void:
	print('am ghost')
	add_to_group("ghosts")
	for other in get_tree().get_nodes_in_group("ghosts"):
		if other != self and other is PhysicsBody2D:
			add_collision_exception_with(other)
			other.add_collision_exception_with(self)

	super.init_current_tile(global_position)
	super.set_target_tile(current_direction)
	
func _find_new_direction() -> Direction:
	var potential_directions = []
	
	if (current_direction == Direction.UP):
		potential_directions = [Direction.LEFT, Direction.RIGHT]
		
	if (current_direction == Direction.DOWN):
		potential_directions = [Direction.LEFT, Direction.RIGHT]
		
	if (current_direction == Direction.LEFT):
		potential_directions = [Direction.DOWN, Direction.UP]
	
	if (current_direction == Direction.RIGHT):
		potential_directions = [Direction.DOWN, Direction.UP]
		
	potential_directions.shuffle()
		
	var potential_tile = current_tile + DIRECTION_VECTORS[potential_directions[0]]
		
	var fist_available = super.check_tile_available(potential_tile)
		
	if (fist_available):
		return potential_directions[0]
	else:
		return potential_directions[1]

	

func _physics_process(delta: float) -> void:
	if (PLAYER_KILLED):
		return	

	if (global_position.distance_to(target_tile_center) < 3):
		# align player to target tile center to avoid drift issues
		global_position = target_tile_center
		_reset_tiles(current_direction)
		
		var target_available = super.check_tile_available(target_tile)

		if (!target_available):
			var new_direction = _find_new_direction()
			current_direction = new_direction
			super.set_target_tile(current_direction)
	

	var movement_vector = Vector2(DIRECTION_VECTORS[current_direction])
	global_position += movement_vector * SPEED * delta
	

	
#	this is a little different than player because we don't need to buffer the
# player's input to feel responsive instead just find a junction and determine a 
# change in direction

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Node:
			_on_collision_shape_entered(collider)
