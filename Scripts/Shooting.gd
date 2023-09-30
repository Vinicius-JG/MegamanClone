extends Node

@onready var anim = $"../AnimationPlayer"
@onready var sprite = $"../Sprite"
@onready var shot = load("res://Scenes/shot.tscn")

@export var offset: float
@export var shotSpeed: float

func _process(delta):
	
	if sprite.flip_h:
		self.position = Vector2(-offset, self.position.y)
	else:
		self.position = Vector2(offset, self.position.y)
		
	
	if Input.is_action_just_pressed("shoot"):
		anim.play("shoot")
		var newShot = shot.instantiate()
		get_node("/root").add_child(newShot)
		newShot.init(self.global_position, -1 if sprite.flip_h else 1, shotSpeed)
		newShot.position = self.global_position
