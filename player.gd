extends CharacterBody2D

class_name Player

signal sanityChanged
signal resourceChanged
signal player_death

const DEFAULT_BASE_RADIUS = 500 # distance where player is considered near/far base
const DEFAULT_INVENTORY_LIMIT = 5 # cap for player resource count
const DEFAULT_SANITY_CAP = 100 # cap at which sanity can no longer be increased
const DEFAULT_SANITY_LOSS = -1 # rate of sanity loss when away from base in sanity per second
const DEFAULT_SANITY_GAIN = 10 # rate of sanity gain when new base in sanity per second
const LOGGING_FREQ_MSEC = 1000 # Period in milliseconds between logging outputs

@export var inventory_limit = DEFAULT_INVENTORY_LIMIT
@export var speed = 400
@onready var character: AnimatedSprite2D = $AnimatedSprite2D


var isRight = true
var is_dead = false
var time_curr = 0
var time_last_logged = 0

var resource_count = 0
var on_resource = null
var on_base = null
var distance_to_base = 0

var maxSanity = DEFAULT_SANITY_CAP
var sanity = DEFAULT_SANITY_CAP
var sanity_loss_modifier = 0 # modifiers which increase or decrease the loss of sanity when away from base
var sanity_gain_modifier = 0 # modifiers which increase or decrease sanity gain when near base
var sanity_cap_modifier = 0 # modifiers which increase or decrease maximum sanity
var base_redius_modifier = 0 # modifiers which increase or decrease the base's radius
var inventory_limit_modifier = 0 # modifiers which increase or decrease player's maximum inventory
var base_enabled = true # whether the base has fuel to ward off the darkness or not

@onready var base = get_parent().get_node('Base')

func update_resources():
	if resource_count < inventory_limit:
		on_resource.resource_count -= 1
		resource_count += 1
		print(str("Player now has ", resource_count, " resources."))
		emit_signal("resourceChanged")
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
	emit_signal("resourceChanged")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		$PauseMenu.pause()

func _physics_process(_delta):
	if is_dead:
		return
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	move_and_slide()
		# Handle horizontal movement and animations
	if Input.is_action_pressed("move_right"):
		character.play("move_right")
		isRight = true
	elif Input.is_action_pressed("move_left"):
		character.play("move_left")
		isRight = false
	elif Input.is_action_just_released("move_right"):
		character.play("stand_right")
	elif Input.is_action_just_released("move_left"):
		character.play("stand_left")

	# Handle vertical movement and animations
	elif Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		if isRight:
			character.play("move_right")
		else:
			character.play("move_left")
	elif Input.is_action_just_released("move_up") or Input.is_action_just_released("move_down"):
		if isRight:
			character.play("stand_right")
		else:
			character.play("stand_left")

func _process(delta):
	time_curr = Time.get_ticks_msec()
	
	# Resource Calculations
	if on_resource != null and Input.is_action_just_pressed("interact"):
		update_resources()
	if on_base != null and Input.is_action_just_pressed("interact"):
		update_base()
	
	# Sanity Calculations
	distance_to_base = base.global_position.distance_to(global_position)
	maxSanity = DEFAULT_SANITY_CAP + sanity_cap_modifier
	var sanity_modifier = 0
	if distance_to_base < (DEFAULT_BASE_RADIUS + base_redius_modifier) and base_enabled:
		sanity_modifier = (DEFAULT_SANITY_GAIN + sanity_gain_modifier) * delta
	else:
		sanity_modifier = (DEFAULT_SANITY_LOSS + sanity_loss_modifier) * delta
	sanity += sanity_modifier
	if sanity <= 0:
		#player has died
		emit_signal("player_death")
		die()
	elif sanity > maxSanity:
		sanity = maxSanity
	else:
		emit_signal("sanityChanged")
	
	# Logging
	if time_curr - time_last_logged > LOGGING_FREQ_MSEC:
		print(str("Player: (distance_to_base: ", distance_to_base, ", sanity: ", sanity, ")"))
		time_last_logged = time_curr

func die() -> void:
	is_dead = true
	print("Player is dead")
	if isRight == true:
		character.play("dead_right")
	else:
		character.play("dead_left")
