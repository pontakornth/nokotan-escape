extends CharacterBody2D
class_name Koshitan
@onready var power_timer = $PowerTimer

@export var initial_speed := 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var speed := initial_speed

func _ready():
	speed = initial_speed

func _physics_process(delta):
	# Add the gravity.
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
	move_and_slide()

func get_power_up():
	power_timer.start()


func _on_power_timer_timeout():
	speed = initial_speed
