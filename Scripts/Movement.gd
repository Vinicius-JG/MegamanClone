extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -325.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_floor = true
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite
@onready var collision = $CollisionShape2D as CollisionShape2D
@onready var slide_collision = $SlideCollisionShape2D as CollisionShape2D


var sliding = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !Input.is_action_pressed("slide"):
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if !sliding: velocity.x = direction * SPEED
	else:
		if !sliding: velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	handle_animations()
	
	if Input.is_action_pressed("slide") and Input.is_action_just_pressed("jump") and is_on_floor() and !sliding:
		sliding = true
		anim.play("slide")
		velocity.x = -1 * SPEED * 1.5 if sprite.flip_h else 1 * SPEED * 1.5
		print(velocity)
		await get_tree().create_timer(0.3).timeout
		velocity.x = 0
		sliding = false
	
	slide_collision.disabled = !sliding
	collision.disabled = sliding	
	
func handle_animations():
	if !sliding:
		if velocity.x != 0 and is_on_floor() and anim.current_animation != "shoot_walk":
			anim.play("walk")

		if velocity.x == 0 and is_on_floor() and anim.current_animation != "shoot":
			anim.play("idle")

		if velocity.y < 0 and !is_on_floor() and anim.current_animation != "shoot_jump":
			anim.play("jump")
			on_floor = false

		if velocity.y > 0 and !is_on_floor() and anim.current_animation != "shoot_jump":
			anim.play("fall")

		if velocity.x > 0:
			sprite.set_flip_h(false)

		if velocity.x < 0:
			sprite.set_flip_h(true)

