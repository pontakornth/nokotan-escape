extends CharacterBody2D
class_name Koshitan
@onready var power_timer = $PowerTimer
@onready var sprite = $AnimatedSprite2D

@export var initial_speed := 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var speed := initial_speed
var sprite_facing_right = false

func _ready():
	speed = initial_speed

func _physics_process(delta):
	# Add the gravity.
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
	if velocity.x > 0 and not sprite_facing_right:
		sprite_facing_right = true
	elif velocity.x < 0 and sprite_facing_right:
		sprite_facing_right = false
	sprite.flip_h = sprite_facing_right
	move_and_slide()

func _input(event: InputEvent):
	if event.is_action_pressed("speed"):
		if DataManager.crisp_rice_count > 0:
			speed = 700
			DataManager.spend_crisp_rice()
			power_timer.start()


func _on_power_timer_timeout():
	speed = initial_speed
