extends Node2D

# Variables para los sprites
onready var mano = $"."


# Propiedades de la animación
var animando = false
var distancia_empuje = 20  # píxeles
var duracion_animacion = 0.3  # segundos
var tiempo_transcurrido = 0.0

func _ready():
	# Conecta algún evento para iniciar la animación (opcional)
	pass

func _process(delta):
	if animando:
		tiempo_transcurrido += delta
		var progreso = min(tiempo_transcurrido / duracion_animacion, 1.0)
		
		# Mueve la mano hacia adelante
		mano.position.x = progreso * distancia_empuje
		
		# Mueve el papel un poco menos para dar sensación de resistencia
		papel.position.x = progreso * (distancia_empuje * 0.8)
		
		if tiempo_transcurrido >= duracion_animacion:
			animando = false
			# Opcional: resetear posición o hacer animación inversa

func iniciar_animacion():
	animando = true
	tiempo_transcurrido = 0.0
