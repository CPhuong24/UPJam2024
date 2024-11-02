extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:
	var viewpoint = get_viewport_rect()
	draw_rect(Rect2(viewpoint.position.x - viewpoint.size.x / 2, viewpoint.position.y - viewpoint.size.y / 2, viewpoint.size.x, viewpoint.size.y), Color.BLACK)
	draw_circle(Vector2(0, 0), 100,  Color(100, 0, 0, 0))
