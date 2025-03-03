extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GP.is_inited:
		go_to_main_scene()
	else:
		GP.inited.connect(go_to_main_scene)


func go_to_main_scene(_success:bool=true):
	get_tree().change_scene_to_file("res://main.tscn")
	
	
