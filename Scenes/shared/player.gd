extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
 #
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		
	var moving_down = Input.is_action_pressed("player_down")
	var moving_up = Input.is_action_pressed("player_up")
	
	if moving_down and !moving_up:
		velocity.y = 1 * SPEED
	if moving_up and !moving_down:
		velocity.y = -1 * SPEED
	if !moving_down and !moving_up:
		velocity.y = 0
		
	var moving_right = Input.is_action_pressed("player_right")
	var moving_left = Input.is_action_pressed("player_left")
		
	if moving_right and !moving_left:
		velocity.x = 1 * SPEED
	if moving_left and !moving_right:
		velocity.x = -1 * SPEED
	if !moving_left and !moving_right:
		velocity.x = 0
		
		
	#if Input.is_action_pressed("player_down"):
		#velocity.y = 1 * SPEED
	#else:
		#velocity.y = 0
		#
	#if Input.is_action_pressed("player_up"):
		#velocity.y = -1 * SPEED
	#else:
		#velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
