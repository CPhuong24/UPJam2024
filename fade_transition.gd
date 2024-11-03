extends CanvasLayer

func _ready():
	# Wait for 5 seconds, then start the fade-out
	await get_tree().create_timer(10.0).timeout
	$AnimationPlayer.play("fade_out")
	get_tree().change_scene_to_file("res://world.tscn")
