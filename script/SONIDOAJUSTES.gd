# Este código debe estar en el script principal de CADA ESCENA
extends Node2D  # O Control, según el tipo de nodo raíz de tu escena

func _ready():
	var escena_actual = get_tree().current_scene.scene_file_path  # Corregido
	print("Ruta real de la escena:", get_tree().current_scene.scene_file_path)
	# ... resto del código
	if escena_actual in [
		"res://escenas/INT0.tscn",  # ¡OJO! ¿Es "INT0" o "INTO"?
		"res://escenas/AJUSTES.tscn",
		"res://escenas/GALERIA.tscn"
	]:
		SonidoGlobal.musica_fondo.play()  # Asegúrate que se llama ControlSonido (no ControlSondo)
	else:
		SonidoGlobal.musica_fondo.stop()
