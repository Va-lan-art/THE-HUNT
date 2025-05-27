extends Node

# Configuración de volumen y estado
var volumen_maestro: float = 0.8  # Volumen inicial (80%)
var esta_muteado: bool = false
var musica_fondo: AudioStreamPlayer

# Lista de escenas donde debe sonar la música (rutas exactas)
var rutas_escenas_con_musica = [
	"res://escenas/INTO.tscn",
	"res://escenas/AJUSTES.tscn", 
	"res://escenas/GALERIA.tscn"
	# Nota: "res://escenas/JUEGO PARTE 1.tscn" NO está incluida, por lo que la música se detendrá ahí
]

func _ready():
	# Configura el reproductor de música
	musica_fondo = AudioStreamPlayer.new()
	add_child(musica_fondo)
	musica_fondo.stream = preload("res://SONIDOS/silent-waves-instrumental-333295.mp3")
	musica_fondo.bus = "Master"
	
	# Espera a que el nodo esté en el árbol antes de acceder a get_tree()
	call_deferred("_iniciar_control_musica")

func _iniciar_control_musica():
	# Verifica la escena actual al iniciar
	_verificar_musica_escena_actual()
	# Conecta la señal para detectar cambios futuros
	get_tree().get_root().connect("ready", _verificar_musica_escena_actual)

func _verificar_musica_escena_actual():
	var escena_actual = get_tree().current_scene.scene_file_path
	print("Depuración - Escena actual:", escena_actual)  # Opcional: para verificar
	
	if escena_actual in rutas_escenas_con_musica:
		if not musica_fondo.playing:
			musica_fondo.play()
	else:
		musica_fondo.stop()

# Función para mute/desmute
func alternar_mute():
	esta_muteado = !esta_muteado
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), esta_muteado)

# Función para ajustar volumen (0.0 a 1.0)
func cambiar_volumen(nuevo_volumen: float):
	volumen_maestro = clamp(nuevo_volumen, 0.0, 1.0)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), 
		linear_to_db(volumen_maestro)
	)
	musica_fondo.volume_db = linear_to_db(volumen_maestro)  # Aplica también al AudioStreamPlayer
