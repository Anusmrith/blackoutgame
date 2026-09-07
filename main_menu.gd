extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed():
	print("Changing scene...")
	get_tree().change_scene_to_file("res://scenes/intro.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene_to_file("res://scenes/game.tscn")
