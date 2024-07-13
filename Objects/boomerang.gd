extends CharacterBody2D
class_name Boomerang
@onready var sprite = $AnimatedSprite2D
@export var speed := 1000.0
@export var deceleration := 300.0
@export var is_corrupted := false
@onready var despawn_timer = $DespawnTimer
@onready var corrupt_timer = $CorruptTimer


var direction := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.rotation_degrees += 720 * delta

func _ready():
	velocity = direction * speed
	if is_corrupted:
		set_collision_layer_value(3, true)
		set_collision_layer_value(2, false)
		sprite.play("corrupted")
		corrupt_timer.start()
		despawn_timer.paused = true

func _on_despawn_timer_timeout():
	queue_free()

func _physics_process(delta):
	if is_corrupted and corrupt_timer.time_left > 0:
		velocity = Vector2.ZERO
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.y = move_toward(velocity.y, 0, deceleration * delta)
	move_and_slide()


func _on_corrupt_timer_timeout():
	velocity = direction * speed
	despawn_timer.paused = false
