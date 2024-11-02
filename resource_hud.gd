extends TextureProgressBar

@onready var player = get_parent().get_parent().get_node('Player')

func _ready() -> void:
	player.resourceChanged.connect(update)
	update()

func update():
	value = player.resource_count * 100 / player.inventory_limit
