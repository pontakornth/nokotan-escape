extends CharacterBody2D
class_name Boomerang
@onready var sprite = $AnimatedSprite2D
@export var speed := 1000.0
@export var deceleration := 300.0

var direction := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.rotation_degrees += 720 * delta

func _ready():
	velocity = direction * speed

func _on_despawn_timer_timeout():
	queue_free()

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	velocity.y = move_toward(velocity.y, 0, deceleration * delta)
	move_and_slide()
