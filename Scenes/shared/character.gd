
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

func set_target_tile(current_direction: Direction) -> void:
	target_tile = current_tile + DIRECTION_VECTORS[current_direction]
	target_tile_center = _find_tile_center(target_tile)

# all characters are bound within walls and cannot go through them. This returns
# wheather or not a specific tile is available based on the data of the tile.
func check_tile_available(tile: Vector2i) -> bool:
	var tile_data = tile_layout.get_cell_tile_data(tile)
	
	if (tile_data):
		var is_wall = tile_data.get_custom_data("wall")
		
		if (is_wall):
			return false
		else:
			return true
		
	return true
