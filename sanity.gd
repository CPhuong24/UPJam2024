extends TextureProgressBar

@export var player: Player

func _ready() -> void:
	player.sanityChanged.connect(update)
	update()

func update():
	value = player.currentSanity * 100 / player.maxSanity
