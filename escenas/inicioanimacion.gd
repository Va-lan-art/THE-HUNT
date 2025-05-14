extends Node2D

@export var tiempo_espera: float = 10
@export var siguiente_escena: String = "res://escenas/JUEGO PARTE 1.tscn"
@export var efecto_fade: bool = true
@export var duracion_fade: float = 10

@onready var fade_rect = $CanvasLayer/FadeRect  

func _ready():
	if efecto_fade and fade_rect:
		fade_rect.color = Color(0, 0, 0, 0) 
	
	var timer = get_tree().create_timer(tiempo_espera)
	timer.timeout.connect(_iniciar_transicion)

func _iniciar_transicion():
	if efecto_fade and fade_rect:
		# Animación de fade out
		var tween = create_tween()
		tween.tween_property(fade_rect, "color:a", 1.0, duracion_fade)
		tween.tween_callback(_cambiar_escena)
	else:
		_cambiar_escena()

func _cambiar_escena():
	if ResourceLoader.exists(siguiente_escena):
		get_tree().change_scene_to_file(siguiente_escena)
	else:
		push_error("Escena no encontrada: " + siguiente_escena)
		
		get_tree().reload_current_scene()
func _on_papel_1_mouse_entered() -> void:
	pass #


func _on_papel_1_mouse_exited() -> void:
	pass 
