
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
var target_tile: Vector2i
var target_tile_center: Vector2

# character is always associated to a current tile, event though it typically is traveling through
# more than one. this method is called on ready() from the child for initial set.
func init_current_tile(child_position: Vector2) -> void:
	current_tile = tile_layout.local_to_map(tile_layout.to_local(child_position))

# child needs to maintain it's own direction I think
# this script should be responsible for telling children if the movement is allowed or not

# this is called when a player has reached the center of a target_tile, meaning we now need
# to update the current and targe tile accordingly
func _reset_tiles(current_direction: Direction) -> void:
	current_tile = target_tile
	set_target_tile(current_direction)

func _find_tile_center(tile_cell: Vector2i) -> Vector2:
	return tile_layout.to_global(tile_layout.map_to_local(tile_cell))

# can probably make a shared _target_tile_available() 
# function that
# 1. moves character to the center of target tile.
# 2. updates target tile based on direction
# 3. returns bool representing if the tile is OK to move into or not,

func set_target_tile(current_direction: Direction) -> void:
	target_tile = current_tile + DIRECTION_VECTORS[current_direction]
	target_tile_center = _find_tile_center(target_tile)

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("Character class ready...")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
