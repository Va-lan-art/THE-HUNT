extends Button

### --- CONFIGURACIÓN DEL INSPECTOR --- ###
@export var nombre_escena: String = ""          
@export var carpeta_escenas: String = "res://escenas/"
@export var es_boton_salida: bool = false       
@export var sonido_personalizado: AudioStream  
@export var activar_animacion_entrada: bool = false

### --- PROPIEDADES DE ANIMACIÓN --- ###
@export var escala_hover: Vector2 = Vector2(1.2, 1.2)
@export var duracion_animacion: float = 0.15

var normal_scale: Vector2 = Vector2.ONE
var tween: Tween

func _ready():
	# Verificación segura del árbol de escena
	if not is_inside_tree():
		await tree_entered
		
	pivot_offset = size / 2
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("pressed", _on_button_pressed)

### --- ANIMACIONES --- ###
func _on_mouse_entered():
	animar_escalado(escala_hover)
	if has_node("SonidoHover"):
		$SonidoHover.play()

func _on_mouse_exited():
	animar_escalado(Vector2.ONE)

func animar_escalado(escala_final: Vector2):
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", escala_final, duracion_animacion)

### --- LÓGICA PRINCIPAL --- ###
func _on_button_pressed():
	if has_node("SonidoPulsado"):
		$SonidoPulsado.play()
	await get_tree().create_timer(0.2).timeout  
	
	if es_boton_salida:
		await salir_del_juego()
	elif nombre_escena != "":
		await cambiar_escena()

### --- FUNCIONES ESPECÍFICAS --- ###
func cambiar_escena():
	var ruta_completa = carpeta_escenas + nombre_escena + ".tscn"
	
	# Verificación segura de recursos
	if not ResourceLoader.exists(ruta_completa):
		push_error("Escena no encontrada: " + ruta_completa)
		return
	
	
	var escena_nueva = load(ruta_completa).instantiate()
	
	var arbol = get_tree()
	if not arbol:
		push_error("No se puede acceder al árbol de escena")
		return
	
	arbol.root.add_child(escena_nueva)
	arbol.current_scene.queue_free()
	arbol.current_scene = escena_nueva
	
	if activar_animacion_entrada:
		await arbol.process_frame
		var anim_player = escena_nueva.find_child("AnimationPlayer")
		if anim_player and anim_player.has_animation("arrastrar_papel"):
			anim_player.play("arrastrar_papel")

func salir_del_juego():
	if sonido_personalizado:
		var audio = AudioStreamPlayer.new()
		audio.stream = sonido_personalizado
		add_child(audio)
		audio.play()
		await audio.finished
	
	get_tree().quit()
