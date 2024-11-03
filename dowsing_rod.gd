extends TextureRect

@onready var player = get_parent().get_parent().get_node('Player')
@onready var frag_1 = get_parent().get_parent().get_node('sun_frag_1')
@onready var frag_2 = get_parent().get_parent().get_node('sun_frag_2')
@onready var frag_3 = get_parent().get_parent().get_node('sun_frag_3')

func get_nearest_frag():
	var frag_1_dist = Vector2(player.position.x, player.position.y - (get_viewport().size.y / 2 - self.position.y)).distance_squared_to(frag_1.position)
	var frag_2_dist = Vector2(player.position.x, player.position.y - (get_viewport().size.y / 2 - self.position.y)).distance_squared_to(frag_2.position)
	var frag_3_dist = Vector2(player.position.x, player.position.y - (get_viewport().size.y / 2 - self.position.y)).distance_squared_to(frag_3.position)
	if frag_1_dist < frag_2_dist and frag_1_dist < frag_3_dist:
		return frag_1
	elif frag_2_dist < frag_1_dist and frag_2_dist < frag_3_dist:
		return frag_2
	return frag_3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#get the nearest fragment
	var nearest_frag = get_nearest_frag()
	# Point the arrow towards the nearest fragment.
	# Use the arrow as the reference point and not the players.
	var arrow_vector = Vector2(player.position.x, player.position.y - (get_viewport().size.y / 2 - self.position.y))
	var angle = arrow_vector.angle_to_point(nearest_frag.position)
	self.rotation = angle + PI/2
