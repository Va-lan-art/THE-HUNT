extends Button

@onready var button_sound = $Jugaraudio  # Asegúrate que el AudioStreamPlayer se llama EXACTAMENTE así

func _ready():
	# Conectamos la señal una sola vez
	pressed.connect(_on_button_pressed)
	
	# Opcional: Ajustar volumen (ej: +3 dB más alto)
	button_sound.volume_db = 3.0

func _on_button_pressed():
	# 1. Primero reproducimos el sonido
	button_sound.play()
	
	# 2. Luego cambiamos de escena (con pequeño delay para que se escuche el sonido)
	await get_tree().create_timer(0.3).timeout  # Ajusta este valor según la duración de tu sonido
	get_tree().change_scene_to_file("res://escenas/INICIOANIMACION.tscn")
