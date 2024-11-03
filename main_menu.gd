extends Control



func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://story_board.tscn")
	 # Replace with function body.


func _on_how_to_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.
