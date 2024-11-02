extends Area2D

@export var resource_count = 0
@onready var player = get_parent().get_node('Player')
@onready var label = $Label

func _ready() -> void:
	player.resourceChanged.connect(update)
	update()

func update():
	label.text = str(resource_count)

func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	player.on_base = self

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	player.on_base = null
