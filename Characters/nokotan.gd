extends CharacterBody2D
class_name Nokotan

@export var initial_speed := 450.0
@onready var sprite = $AnimatedSprite2D

var speed = initial_speed
var koshitan: Koshitan
var chasing_koshitan := true
@onready var power_timer = $PowerTimer

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
	move_and_slide()


func chase_koshitan():
	if koshitan != null:
		velocity = position.direction_to(koshitan.position) * speed
	

func _on_area_2d_body_entered(body):
	# Get game over if it is Koshitan
	if body is Koshitan:
		get_tree().change_scene_to_file("res://System/game_over.tscn")
		
func get_power_up():
	speed = 900
	power_timer.start()


func _on_power_timer_timeout():
	speed = initial_speed
