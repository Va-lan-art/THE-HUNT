extends Button

### --- CONFIGURACIÓN DEL INSPECTOR --- ###
@export var nombre_escena: String = ""          # Ej: "MENU" (ignorado si es_boton_salida=true)
@export var carpeta_escenas: String = "res://escenas/"
@export var es_boton_salida: bool = false       # Marca esto para que el botón cierre el juego
@export var sonido_personalizado: AudioStream   # Sonido para salida (opcional)

### --- PROPIEDADES DE ANIMACIÓN --- ###
@export var escala_hover: Vector2 = Vector2(1.1, 1.1)
@export var duracion_animacion: float = 0.15

### --- VARIABLES INTERNAS --- ###
var normal_scale: Vector2 = Vector2.ONE
var tween: Tween

func _ready():
	# Configuración inicial
	await get_tree().process_frame
	pivot_offset = size / 2
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("pressed", _on_button_pressed)

### --- ANIMACIONES --- ###
func _on_mouse_entered():
	animar_escalado(escala_hover)
	$SonidoHover.play()

func _on_mouse_exited():
	animar_escalado(Vector2.ONE)

func animar_escalado(escala_final: Vector2):
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", escala_final, duracion_animacion)

### --- LÓGICA PRINCIPAL --- ###
func _on_button_pressed():
	$SonidoPulsado.play()
	await get_tree().create_timer(0.2).timeout  # Espera mínima
	
	if es_boton_salida:
		await salir_del_juego()
	elif nombre_escena != "":
		cambiar_escena()

### --- FUNCIONES ESPECÍFICAS --- ###
func cambiar_escena():
	var ruta_completa = carpeta_escenas + nombre_escena + ".tscn"
	if ResourceLoader.exists(ruta_completa):
		get_tree().change_scene_to_file(ruta_completa)
	else:
		push_error("Escena no encontrada: " + ruta_completa)

func salir_del_juego():
	if sonido_personalizado:
		var audio = AudioStreamPlayer.new()
		audio.stream = sonido_personalizado
		add_child(audio)
		audio.play()
		await audio.finished
	
	get_tree().quit()  # Cierra el juego
	# Para web: JavaScriptBridge.eval("window.close()", true)
