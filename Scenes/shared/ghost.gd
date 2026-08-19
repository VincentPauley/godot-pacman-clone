extends Character

# This class controls what the enemies and player have in common, the way they
# are allowed to move within the level restricted by walls.

var SPEED = 25

var current_direction: Direction = Direction.LEFT

func _ready() -> void:
	super.init_current_tile(global_position)
	print("i am the ghost, tile:")
	print(current_tile)
	# first up... what tile am I
	


func _physics_process(delta: float) -> void:

	var movement_vector = Vector2(DIRECTION_VECTORS[current_direction])
	global_position += movement_vector * SPEED * delta

	move_and_slide()
