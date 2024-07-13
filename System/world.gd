extends Node2D
@onready var koshitan = $Koshitan
@onready var nokotan = $Nokotan

@export var spawn_item: PackedScene
@export var spawn_radius := 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	
