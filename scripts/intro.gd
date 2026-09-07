extends Control

func _on_timer_timeout() -> void:
	print("Timer finished")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
