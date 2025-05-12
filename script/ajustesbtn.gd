extends Button

@onready var button_sound = $Sonidoajustes  # Asegúrate de que el nodo se llama EXACTAMENTE así

func _ready():
	# Conectamos UNA sola vez la señal 'pressed' a una función que hará AMBAS cosas
	pressed.connect(_on_button_pressed)  

func _on_button_pressed():
	# 1. Reproduce el sonido
	button_sound.play()  
	
	# 2. Cambia de escena (opcional: con un pequeño delay para que se escuche el sonido)
	await get_tree().create_timer(0.2).timeout  # Espera 0.2 segundos (ajústalo)
	get_tree().change_scene_to_file("res://escenas/AJUSTES.tscn")
