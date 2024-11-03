extends Control

@export var item_name = "Item"
@export var description = "Description."
@export var price = "5"
var bought = false
@onready var item_icon = $"HBoxContainer/Item Icon"
@onready var name_label = $HBoxContainer/VBoxContainer/Name
@onready var description_label = $HBoxContainer/VBoxContainer/Description
@onready var price_label = $HBoxContainer/Price
@onready var resource_icon = $"HBoxContainer/Resource Icon"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = item_name
	description_label.text = description
	item_icon.texture_normal = load(str("res://Art Assests/", item_name, ".png")) # Expect item icon to be placed under Art Assets as a png with the same name as the item name.
	price_label.text = str(price)
