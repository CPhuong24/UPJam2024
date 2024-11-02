extends CharacterBody2D

@export var speed = 400
var resource_count = 0
@export var inventory_limit = 5
var on_resource = null
var on_base = null
var sanity = 100
var distance_to_base = 0
const DEFAULT_BASE_RADIUS = 500 # distance where player is considered near/far base
const DEFAULT_SANITY_CAP = 100 # cap at which sanity can no longer be increased
const DEFAULT_SANITY_LOSS = -1 # rate of sanity loss when away from base in sanity per second
const DEFAULT_SANITY_GAIN = 10 # rate of sanity gain when new base in sanity per second
var sanity_loss_modifier = 0 # modifiers which increase or decrease the loss of sanity when away from base
var sanity_gain_modifier = 0 # modifiers which increase or decrease sanity gain when near base
var sanity_cap_modifier = 0 # modifiers which increase or decrease maximum sanity
var base_redius_modifier = 0 # modifiers which increase or decrease the base's radius
@onready var base = get_parent().get_node('Base')
signal player_death()

func update_resources():
	if resource_count < inventory_limit:
		on_resource.resource_count -= 1
		resource_count += 1
		print(str("Player now has ", resource_count, " resources."))
		if on_resource.resource_count == 0:
			print("Resource exhausted.")
			on_resource.queue_free()
	else:
		print("Player's inventory is full.")
		
func update_base():
	on_base.resource_count += resource_count
	print(str("Player entered base with ", resource_count, " resources and dropped off resources."))
	print("Base now has ", on_base.resource_count, " resources.")
	resource_count = 0

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _process(delta):
	# Resource Calculations
	if on_resource != null and Input.is_action_just_pressed("interact"):
		update_resources()
	if on_base != null and Input.is_action_just_pressed("interact"):
		update_base()
	# Sanity Calculations
	distance_to_base = base.global_position.distance_to(global_position)
	if distance_to_base > (DEFAULT_BASE_RADIUS + base_redius_modifier):
		sanity += (DEFAULT_SANITY_LOSS + sanity_loss_modifier) * delta
		if sanity <= 0:
			#player has died
			emit_signal("player_death")
			print("Player death signaled")
	else:
		sanity += (DEFAULT_SANITY_GAIN + sanity_gain_modifier) * delta
		if sanity >= (DEFAULT_SANITY_CAP + sanity_cap_modifier):
			sanity = DEFAULT_SANITY_CAP + sanity_cap_modifier
	print(str("Player distance and sanity: (", distance_to_base, ", ", sanity, ")"))
	
