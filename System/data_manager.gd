extends Node

var crisp_rice_count: int = 0

signal update_crisp_rice_count(new_count: int)

func get_crisp_rice():
	# This one is for Koshitan only
	crisp_rice_count += 1
	update_crisp_rice_count.emit(crisp_rice_count)

func spend_crisp_rice():
	crisp_rice_count -= 1
	update_crisp_rice_count.emit(crisp_rice_count)