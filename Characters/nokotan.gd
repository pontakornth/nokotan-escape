extends CharacterBody2D

@export var speed := 450.0
var koshitan: Koshitan

func _ready():
	# Parent of Nokotan is the World
	for child in get_parent().get_children():
		if child is Koshitan:
			koshitan = child
			

func _physics_process(delta):
	if koshitan != null:
		velocity = position.direction_to(koshitan.position) * speed
	move_and_slide()


func _on_area_2d_body_entered(body):
	# Get game over if it is Koshitan
	if body is Koshitan:
		get_tree().change_scene_to_file("res://System/game_over.tscn")
