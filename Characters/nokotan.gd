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
