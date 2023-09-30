extends Area2D

@onready var sprite = $Sprite
var speed

func init(startPos, dir, speed):
	self.position = startPos
	self.speed = speed * dir
	sprite.flip_h = dir == -1

func _process(delta):
	translate(Vector2(speed * delta, 0))
