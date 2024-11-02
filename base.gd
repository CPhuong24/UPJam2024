extends Area2D

@export var resource_count = 0
@export var light_energy = 0.5
@onready var player = get_parent().get_node('Player')
@onready var light = get_node('PointLight2D')
@onready var label = $Label
@onready var progress_bar = $TextureProgressBar
const BASE_RESOURCE_CONSUMPTION = 2 # how quickly in durability/sec the base consumes resources
const RESOURCE_DURABILITY = 100
var resource_consumption_modifier = 0 # modifiers which slow down or speed up resource consumption by the base
var consumption_rate = BASE_RESOURCE_CONSUMPTION
var current_durability = RESOURCE_DURABILITY

func _ready() -> void:
	player.resourceChanged.connect(update)
	update()

func update():
	label.text = str(resource_count)

func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	player.on_base = self

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	player.on_base = null
	
func _process(delta: float) -> void:
	if current_durability > 0:
		current_durability -= consumption_rate * delta
	else:
		if resource_count > 0:
			resource_count -= 1
			update()
			current_durability = RESOURCE_DURABILITY
			light.energy = light_energy
			player.base_enabled = true
		else:
			current_durability = 0
			player.base_enabled = false
			light.energy = 0
	progress_bar.value = current_durability
