extends CanvasLayer

func _ready():
	# Wait for 5 seconds, then start the fade-out
	await get_tree().create_timer(9.0).timeout
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://world.tscn")
