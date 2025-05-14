extends Node2D


var images = [
	preload("res://galeria/2025-05-03_154007 (6).jpg"),
	preload("res://galeria/2025-05-03_145743 (4).jpg"),
	preload("res://galeria/2025-05-03_144448 (3).jpg"),
]
var current_index = 0

@onready var texture_rect = $CanvasLayer/MarginContainer/VBoxContainer/TextureRect

func _ready():
	update_image()

func update_image():
	if images.size() > 0:
		texture_rect.texture = images[current_index]

func _on_prev_button_pressed():
	current_index = max(0, current_index - 1)
	update_image()

func _on_next_button_pressed():
	current_index = min(images.size() - 1, current_index + 1)
	update_image()
