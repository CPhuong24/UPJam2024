extends VBoxContainer

@onready var frag1: TextureRect = $Fragment1
@onready var frag2: TextureRect = $Fragment2
@onready var frag3: TextureRect = $Fragment3
@onready var player = get_parent().get_parent().get_node('Player')

func _ready() -> void:
	player.sunFragChanged.connect(update)

func update(frag):
	if frag.name == "sun_frag_1":
		frag1.texture = load("res://sun_fragments/sun_fragment_1.png")
	if frag.name == "sun_frag_2":
		frag2.texture = load("res://sun_fragments/sun_fragment_2.png")
	if frag.name == "sun_frag_3":
		frag3.texture = load("res://sun_fragments/sun_fragment_3.png")
	
