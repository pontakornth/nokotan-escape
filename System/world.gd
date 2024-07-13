extends Node2D
@onready var koshitan = $Koshitan
@onready var nokotan = $Nokotan

@export var spawn_item: PackedScene
@export var deer: PackedScene
@export var boomerang: PackedScene
@export var spawn_radius := 500

# Called when the node enters the scene tree for the first time.
func _ready():
	DataManager.spawn_deer.connect(spawn_deer)
	DataManager.delete_deer.connect(delete_deer)
	DataManager.launch_boomerang.connect(launch_boomerang)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_spawn_timer_timeout():
	# Spawn item
	# Item must be around either Nokotan or Koshitan
	# I use square because it is simpler
	var ref_position: Vector2
	if randi_range(0, 1) == 0:
		# Koshitan
		ref_position = koshitan.position
	else:
		ref_position = nokotan.position
	var position := Vector2(
		randf_range(ref_position.x - spawn_radius, ref_position.x + spawn_radius),
		randf_range(ref_position.y - spawn_radius, ref_position.y + spawn_radius),
	) 
	
	var item = spawn_item.instantiate()
	if item is Node2D:
		item.position = position
	add_child(item)
	
func spawn_deer():
	var deer_position: Vector2 = koshitan.position
	while true:
		deer_position = Vector2(
			randf_range(koshitan.position.x - spawn_radius, koshitan.position.x + spawn_radius),
			randf_range(koshitan.position.y - spawn_radius, koshitan.position.y + spawn_radius),
			
		)
		if deer_position.distance_to(koshitan.position) >= 300:
			break
	var actual_deer = deer.instantiate() as Node2D
	actual_deer.position = deer_position
	add_child(actual_deer)

func delete_deer():
	var all_deer_nodes := get_tree().get_nodes_in_group("deer")
	for deer in all_deer_nodes:
		deer.queue_free()

func _input(event: InputEvent):
	if event.is_action_pressed("debug_deer"):
		spawn_deer()

func launch_boomerang():
	for i in range(8):
		var actual_boomerang = boomerang.instantiate() as Boomerang
		actual_boomerang.direction = Vector2.from_angle(deg_to_rad(45 * i))
		actual_boomerang.position = koshitan.position
		add_child(actual_boomerang)
		
