extends Button

@onready var button_sound = $Sonidogaleria  # 🔥 Nombre exacto del nodo de audio

func _ready():
	# Conecta la señal 'pressed' para manejar AMBAS acciones (sonido + cambio de escena)
	pressed.connect(_on_button_pressed)  

func _on_button_pressed():
	# 1. Reproduce el sonido del botón
	button_sound.play()  
	
	# 2. Cambia a la escena GALERIA (con pequeño delay para escuchar el sonido)
	await get_tree().create_timer(0.2).timeout  # ⏳ Ajusta el tiempo si es necesario
	get_tree().change_scene_to_file("res://escenas/GALERIA.tscn")
