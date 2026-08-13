extends Area2D

#var level = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body is CharacterBody2D:
		var level = get_parent()
		if level.has_method("handle_pellet_pickup"):
			level.handle_pellet_pickup()
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
