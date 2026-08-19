
extends CharacterBody2D
class_name Character

@export var tile_layout: TileMapLayer

enum Direction { NONE, UP, DOWN, LEFT, RIGHT }

const DIRECTION_VECTORS = {
	Direction.UP: Vector2i(0, -1),
	Direction.DOWN: Vector2i(0, 1),
	Direction.LEFT: Vector2i(-1, 0),
	Direction.RIGHT: Vector2i(1, 0)
}

var current_tile: Vector2i


# character is always associated to a current tile, event though it typically is traveling through
# more than one. this method is called on ready() from the child for initial set.
func init_current_tile(child_position: Vector2) -> void:
	current_tile = tile_layout.local_to_map(tile_layout.to_local(child_position))

# child needs to maintain it's own direction I think
# this script should be responsible for telling children if the movement is allowed or not


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("Character class ready...")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
