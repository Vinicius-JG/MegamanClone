extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -325.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_floor = true
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	handle_animations()
	
func handle_animations():
	if velocity.x != 0 and is_on_floor():
		anim.play("walk")

	if velocity.x == 0 and is_on_floor() and anim.current_animation != "shoot":
		anim.play("idle")

	if velocity.y < 0 and !is_on_floor():
		anim.play("jump")
		on_floor = false

	if velocity.y > 0 and !is_on_floor():
		anim.play("fall")

	if velocity.x > 0:
		sprite.set_flip_h(false)

	if velocity.x < 0:
		sprite.set_flip_h(true)
