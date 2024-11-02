extends CharacterBody2D

class_name Player

signal sanityChanged

@export var speed = 400
var resource_count = 0
@export var inventory_limit = 5
var on_resource = null
var on_base = null
@export var maxSanity = 100
@onready var currentSanity: int = maxSanity

func _ready():
	remove_sanity(50)
	add_sanity(25)

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

func _process(_delta):
	if on_resource != null and Input.is_action_just_pressed("interact"):
		update_resources()
	if on_base != null and Input.is_action_just_pressed("interact"):
		update_base()
		
func remove_sanity(amount: int) -> void:
	currentSanity -= amount
	sanityChanged.emit()
	if currentSanity <= 0:
		die()
	else:
		print("Sanity: ", currentSanity)

func add_sanity(amount: int) -> void:
	currentSanity += amount
	sanityChanged.emit()
	if currentSanity > maxSanity:
		currentSanity = maxSanity
	print("Sanity: ", currentSanity)

func die() -> void:
	print("Player is dead")
