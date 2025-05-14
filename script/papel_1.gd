extends Area2D

# Variables de control
var can_interact = true
var zoom_active = true
var original_zoom = Vector2(1, 1)
var zoom_level = Vector2(2, 2)

# Referencias a nodos con tipado seguro
@onready var mano: Sprite2D = $"../Mano"
@onready var camera: Camera2D = $"../Camera2D"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	# Verificar que todos los nodos necesarios existen
	if not mano or not camera or not collision_shape:
		push_error("Faltan nodos requeridos en la escena")
		return
	
	# Esperar el tiempo de la animación (ajustar según necesidad)
	await get_tree().create_timer(100).timeout
	
	# Ocultar la mano con desvanecimiento
	var tween = create_tween()
	tween.tween_property(mano, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): mano.visible = false)
	
	# Activar interacción
	can_interact = true
	collision_shape.disabled = false  
	print("Papel ahora es interactuable") 

func _input_event(_viewport, event: InputEvent, _shape_idx):
	if not can_interact:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		zoom_active = not zoom_active
		var target_zoom = zoom_level if zoom_active else original_zoom
		
		# Animación suave del zoom
		var zoom_tween = create_tween().set_trans(Tween.TRANS_SINE)
		zoom_tween.tween_property(camera, "zoom", target_zoom, 0.3)
		print("Zoom cambiado a:", target_zoom)  


func _on_mouse_entered():
	if can_interact:
		print("Mouse sobre el papel")

func _on_mouse_exited():
	if can_interact:
		print("Mouse fuera del papel")
