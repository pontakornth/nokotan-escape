extends CharacterBody2D
class_name Nokotan

@export var initial_speed := 450.0
@onready var sprite = $AnimatedSprite2D
@onready var crispy_request = $CrispyRequest

var latest_timestamp: int = -1
var speed = initial_speed
var koshitan: Koshitan
var chasing_koshitan := true
var should_accelerate := false
@onready var power_timer = $PowerTimer
@onready var stun_timer = $StunTimer
@onready var ai_request = $AIRequest


func _ready():
	# Parent of Nokotan is the World
	speed = initial_speed
	for child in get_parent().get_children():
		if child is Koshitan:
			koshitan = child

func _input(event: InputEvent):
	if event.is_action_pressed("debug_switch_ai"):
		chasing_koshitan = !chasing_koshitan

func _physics_process(delta):
	if chasing_koshitan:
		chase_koshitan()
	else:
		chase_crisp_rice()
	sprite.flip_h = velocity.x > 0
	if stun_timer.time_left > 0:
		velocity = Vector2.ZERO
	move_and_slide()


func chase_koshitan():
	if koshitan != null:
		velocity = position.direction_to(koshitan.position) * speed
		
func chase_crisp_rice():
	var all_crisp_rices = get_tree().get_nodes_in_group("crisp")
	var all_positions = []
	for c in all_crisp_rices:
		all_positions.append((c as Node2D).position)
	if all_positions.is_empty():
		# Stop
		velocity = Vector2.ZERO
	else:
		# Find the nearest position
		# TODO: Optimize 
		var closest_position = all_positions[0]
		var shortest_distance = position.distance_to(closest_position)
		for point in all_positions:
			var current_distance := position.distance_to(point)
			if current_distance < current_distance:
				closest_position = point
				shortest_distance = current_distance
		velocity = position.direction_to(closest_position) * speed
	

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
	# TODO: Update URL
	#crispy_request.request("http://localhost:5173/api/move",PackedStringArray(),HTTPClient.METHOD_POST)
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


func _on_ai_request_request_completed(result, response_code, headers, body):
	# TODO: Change URL and AI
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
	if latest_timestamp <= json["timestamp"] and latest_timestamp > 0:
		return
	latest_timestamp = json["timestamp"]
	# Change AI
	var current_ai = json["ai"]
	print(current_ai)
	if current_ai == 1:
		chasing_koshitan = true
	elif current_ai == 2:
		chasing_koshitan = false
	
	var current_skill = json["skill"]
	if current_skill == 1:
		accelerate()
	elif current_skill == 2:
		DataManager.spawn_deer.emit()
	elif current_skill == 3:
		DataManager.launch_bullets.emit()


func _on_ai_timer_timeout():
	ai_request.request(DataManager.AI_URL, [], HTTPClient.METHOD_GET)
	print("Submit request")
