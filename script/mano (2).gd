extends Sprite2D

@export var tiempo_espera: float = 4  # Configurable desde el inspector
@export var duracion_desvanecimiento: float = 2
@export var eliminar_al_final: bool = true  

func _ready():
	
	await get_tree().create_timer(tiempo_espera).timeout
	desvanecer()

func desvanecer():
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "modulate:a", 0.0, duracion_desvanecimiento)
	
	# Opcional: Añadir efecto de escala simultáneo
	tween.parallel().tween_property(self, "scale", scale * 0.8, duracion_desvanecimiento)
	
	# Acción final (ocultar o eliminar el nodo)
	if eliminar_al_final:
		tween.tween_callback(queue_free)
	else:
		tween.tween_callback(set.bind("visible", false))
		
