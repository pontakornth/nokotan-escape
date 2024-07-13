extends CharacterBody2D


@export var initial_speed := 0
@export var acceleration := 200
@export var max_speed := 450

var speed: float

var koshitan: Koshitan

func _ready():
	speed = initial_speed
	for child in get_parent().get_children():
		if child is Koshitan:
			koshitan = child


func _physics_process(delta):
	velocity = position.direction_to(koshitan.position) * speed
	speed = move_toward(speed, max_speed, acceleration * delta)
	move_and_slide()


func _on_despawn_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Koshitan:
		get_tree().change_scene_to_file("res://System/game_over.tscn")
