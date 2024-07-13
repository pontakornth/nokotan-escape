extends CharacterBody2D
class_name Koshitan

@export var speed := 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.



func _physics_process(delta):
	# Add the gravity.
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
	move_and_slide()
