extends Node2D

@export var resource: PackedScene = preload("res://resource.tscn")
@export var num_to_spawn = 40

### CHANGE THE NUM TO SPAWN
### CHANGE THE MAP BOUNDARIES TO THE NEW MAP!!!!
# Map boundaries
var top_left = Vector2(-3000, -1500)
var bottom_right = Vector2(3200, 1900)

#base size. avoids tree spawning on base
var base_top_left = Vector2(-500, -500)
var base_bottom_right = Vector2(500, 500)


# Size of each tree (resource dimensions + spacing)
var cell_width = 120 
var cell_height = 220  


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn_pos = get_valid_pos()	
	for i in range(num_to_spawn):
		if spawn_pos.size() == 0:
			print("No more valid spawn positions available.")
			break
			
		var position = spawn_pos.pick_random()
		spawn_area2d(position)
		print(i)
		spawn_pos.erase(position)
		
	pass # Replace with function body.

func spawn_area2d(position: Vector2):
	var reso_instance = resource.instantiate()  # Create a new Area2D instance
	reso_instance.position = position  # Set its position
	add_child(reso_instance)  # Add it as a child of this node (or the tilemap, if needed)

func get_valid_pos() -> Array:
	var valid_positions = []

	var x_start = top_left.x
	var y_start = top_left.y
	var x_end = bottom_right.x
	var y_end = bottom_right.y
	
	for x in range(x_start, x_end, cell_width):
		for y in range(y_start, y_end, cell_height):
			var posi = Vector2(x, y)
			if not is_inside_base(posi):
				valid_positions.append(Vector2(x, y))
	
	return valid_positions
	
func is_inside_base(position: Vector2) -> bool:
	return position.x >= base_top_left.x and position.x <= base_bottom_right.x and position.y >= base_top_left.y and position.y <= base_bottom_right.y
