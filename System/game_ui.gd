extends CanvasLayer
@onready var crisp_count = %CrispCount


# Called when the node enters the scene tree for the first time.
func _ready():
	DataManager.update_crisp_rice_count.connect(update_count_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_count_text(new_count: int):
	crisp_count.text = "%d / 3" % new_count
