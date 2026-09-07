extends Control

func _ready():
	visible = false

func resume():
	get_tree().paused = false
	visible = false

func restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
