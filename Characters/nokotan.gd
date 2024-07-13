extends CharacterBody2D
class_name Nokotan

@export var initial_speed := 450.0
@onready var sprite = $AnimatedSprite2D

var speed = initial_speed
var koshitan: Koshitan
var chasing_koshitan := true
@onready var power_timer = $PowerTimer
@onready var stun_timer = $StunTimer


func _ready():
	# Parent of Nokotan is the World
	speed = initial_speed
	for child in get_parent().get_children():
		if child is Koshitan:
			koshitan = child
			

func _physics_process(delta):
	if chasing_koshitan:
		chase_koshitan()
	sprite.flip_h = velocity.x > 0
	if stun_timer.time_left > 0:
		velocity = Vector2.ZERO
	move_and_slide()


func chase_koshitan():
	if koshitan != null:
		velocity = position.direction_to(koshitan.position) * speed
	

func _on_area_2d_body_entered(body):
	# Get game over if it is Koshitan
	if body is Koshitan:
		get_tree().change_scene_to_file("res://System/game_over.tscn")
	if body is Boomerang:
		stun_timer.start()
		sprite.modulate = Color.DIM_GRAY
		body.queue_free()
		
func get_power_up():
	# random behavior
	var result := randi_range(0, 2)
	if result == 0:
		DataManager.spawn_deer.emit()
	elif result == 1:
		accelerate()
	elif result == 2:
		DataManager.launch_bullets.emit()

func accelerate():
	speed = 900
	sprite.play("danger")
	power_timer.start()

func _on_power_timer_timeout():
	speed = initial_speed
	sprite.play("default")


func _on_stun_timer_timeout():
	sprite.modulate = Color.WHITE
