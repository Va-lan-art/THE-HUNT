extends Node

# Configuración inicial
var volumen_maestro: float = 0.8
var esta_muteado: bool = false
var musica_fondo: AudioStreamPlayer

# Lista de ESCENAS CON MÚSICA (¡usa tus rutas exactas!)
var escenas_con_musica = [
	"res://escenas/INTO.tscn", 
	"res://escenas/AJUSTES.tscn", 
	"res://escenas/GALERIA.tscn"
]

func _ready():
	# Prepara la música
	musica_fondo = AudioStreamPlayer.new()
	add_child(musica_fondo)
	musica_fondo.stream = preload("res://SONIDOS/silent-waves-instrumental-333295.mp3")  # ¡Cambia por tu archivo!
	musica_fondo.bus = "Master"
	
	# Verifica la escena actual al iniciar
	_actualizar_musica()
	# Conecta la señal para cambios de escena
	get_tree().tree_changed.connect(_actualizar_musica)

func _actualizar_musica():
	var escena_actual = get_tree().current_scene.scene_file_path  # Obtiene la ruta COMPLETA
	if escena_actual in escenas_con_musica:
		if not musica_fondo.playing:
			musica_fondo.play()
	else:
		musica_fondo.stop()

func alternar_mute():
	esta_muteado = !esta_muteado
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), esta_muteado)

func cambiar_volumen(nuevo_volumen: float):
	volumen_maestro = clamp(nuevo_volumen, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volumen_maestro))
