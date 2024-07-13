extends Area2D
class_name CrispRice

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.ß


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Koshitan:
		# Koshitan cannot get more than 3 
		if DataManager.crisp_rice_count < 3:
			DataManager.get_crisp_rice()
			queue_free()
	if body is Nokotan:
		body.get_power_up()
		queue_free()
