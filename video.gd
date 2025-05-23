extends Control

@export var video_path: String = ""

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var btn_volver: Button = $BtnVolver

func _ready():
	video_player.stream = load(video_path)
	video_player.play()
	
	# Configura el botón de volver con tu sistema de botones
	btn_volver.es_boton_galeria = false
	btn_volver.nombre_escena = ""  # No cambiará escena
	btn_volver.connect("pressed", _on_volver_presionado)

func _on_volver_presionado():
	video_player.stop()
	queue_free()
