extends MarginContainer

@export var imagenes_por_pagina: int = 4
@export var ruta_galeria: String = "res://galeria/"

var imagenes: Array = []
var pagina_actual: int = 0

@onready var grid: GridContainer = $Panel/GridContainer 
@onready var boton_anterior: Button = get_node("/root/Node2D/Anterior")
@onready var boton_siguiente: Button = get_node("/root/Node2D/Siguiente")

signal imagen_seleccionada(texture_rect: TextureRect)

func _ready():
	await get_tree().process_frame  # Espera a que los nodos estén listos
	
	if not grid:
		push_error("GridContainer no encontrado!")
		return
	
	cargar_imagenes()
	_aplicar_estilos()
	actualizar_pagina()
	conectar_botones()

# Estilo
func _aplicar_estilos():
	var estilo_borde = StyleBoxFlat.new()
	estilo_borde.bg_color = Color(0.0, 0.0, 0.0, 0.0)  # Fondo semitransparente
	estilo_borde.border_color = Color(47/255.0, 18/255.0, 5/255.0)
	estilo_borde.set_border_width_all(5)
	estilo_borde.set_corner_radius_all(5)
	estilo_borde.set_content_margin_all(10)

	for hijo in grid.get_children():
		if hijo is TextureRect:
			# Ajustes de tamaño
			hijo.custom_minimum_size = Vector2(350, 250)  # Ancho x Alto
			hijo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			hijo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			
			# Borde como nodo hijo (alternativa mejorada)
			var borde = Panel.new()
			borde.add_theme_stylebox_override("panel", estilo_borde)
			borde.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			borde.mouse_filter = Control.MOUSE_FILTER_IGNORE
			hijo.add_child(borde)
			
			# Debug visual (opcional)
			hijo.modulate = Color.WHITE  # Asegura visibilidad

func _on_texture_rect_input(event: InputEvent, texture_rect: TextureRect):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("imagen_seleccionada", texture_rect)

func cargar_imagenes():
	var dir = DirAccess.open(ruta_galeria)
	if dir:
		dir.list_dir_begin()
		var nombre_archivo = dir.get_next()
		while nombre_archivo != "":
			if nombre_archivo.ends_with(".png") or nombre_archivo.ends_with(".jpg"):
				imagenes.append(ruta_galeria + nombre_archivo)
			nombre_archivo = dir.get_next()

func actualizar_pagina():  # ¡CORRECCIÓN CLAVE AQUÍ!
	var inicio = pagina_actual * imagenes_por_pagina
	var fin = inicio + imagenes_por_pagina
	
	boton_anterior.disabled = (pagina_actual == 0)
	boton_siguiente.disabled = (fin >= imagenes.size())
	
	for i in range(grid.get_child_count()):
		var texture_rect = grid.get_child(i) as TextureRect
		if texture_rect:
			if inicio + i < imagenes.size():
				texture_rect.texture = load(imagenes[inicio + i])  # Usamos .texture, no .texture_normal
				texture_rect.visible = true
			else:
				texture_rect.visible = false

func conectar_botones():
	boton_anterior.galeria_anterior_presionado.connect(_on_anterior_presionado)
	boton_siguiente.galeria_siguiente_presionado.connect(_on_siguiente_presionado)

func _on_anterior_presionado():
	if pagina_actual > 0:
		pagina_actual -= 1
		actualizar_pagina()

func _on_siguiente_presionado():
	if (pagina_actual + 1) * imagenes_por_pagina < imagenes.size():
		pagina_actual += 1
		actualizar_pagina()
