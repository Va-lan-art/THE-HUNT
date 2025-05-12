extends Control  # Asegúrate de que tu nodo raíz es un Control

var image_paths = []
var current_image_index = 0

# Referencias a nodos - AJUSTA ESTOS NOMBRES A TU ESTRUCTURA REAL
@onready var main_image: TextureRect = $Galeria/MainImage
@onready var prev_button = $Galeria/NavigationButtons/Prev
@onready var next_button = $Galeria/NavigationButtons/Next
@onready var thumbnails_container = $Galeria/ThumbailContainer  # Nota el typo "Thumbail"
@onready var back_button = $Galeria/Atras

func _ready():
	# Verificar que todos los nodos existen antes de usarlos
	if not main_image:
		push_error("MainImage no encontrado! Verifica la ruta del nodo.")
		return
	if not prev_button:
		push_error("Botón Prev no encontrado! Verifica la ruta del nodo.")
		return
	if not next_button:
		push_error("Botón Next no encontrado! Verifica la ruta del nodo.")
		return
	if not thumbnails_container:
		push_error("ThumbailContainer no encontrado! Verifica la ruta del nodo.")
		return
	
	# Conectar señales de los botones
	prev_button.pressed.connect(_on_prev_button_pressed)
	next_button.pressed.connect(_on_next_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	load_images_from_folder("res://galeria/")
	update_gallery()

func load_images_from_folder(folder_path):
	image_paths.clear()
	
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.get_extension().to_lower() in ["png", "jpg", "jpeg", "webp"]:
				var full_path = folder_path.path_join(file_name)
				if ResourceLoader.exists(full_path):
					image_paths.append(full_path)
				else:
					push_warning("No se puede cargar: " + full_path)
			file_name = dir.get_next()
	else:
		push_error("No se pudo abrir la carpeta: " + folder_path)
	
	print("Imágenes encontradas (" + str(image_paths.size()) + "):")
	for path in image_paths:
		print(" - " + path)

func update_gallery():
	if image_paths.size() == 0:
		push_warning("No hay imágenes para mostrar")
		main_image.texture = null
		return
	
	current_image_index = clamp(current_image_index, 0, image_paths.size() - 1)
	
	var main_texture = load(image_paths[current_image_index])
	if main_texture:
		main_image.texture = main_texture
	else:
		push_error("No se pudo cargar la textura: " + image_paths[current_image_index])
	
	update_thumbnails()
	update_buttons_state()

func update_thumbnails():
	for child in thumbnails_container.get_children():
		child.queue_free()
	
	for i in range(image_paths.size()):
		var texture = load(image_paths[i])
		if texture:
			var thumbnail = TextureRect.new()
			thumbnail.texture = texture
			thumbnail.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			thumbnail.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			thumbnail.custom_minimum_size = Vector2(80, 80)
			
			var margin = MarginContainer.new()
			margin.add_theme_constant_override("margin_right", 10)
			margin.add_child(thumbnail)
			thumbnails_container.add_child(margin)
			
			thumbnail.gui_input.connect(
				func(event):
					if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
						current_image_index = i
						update_gallery()
			)

func update_buttons_state():
	prev_button.disabled = current_image_index <= 0
	next_button.disabled = current_image_index >= image_paths.size() - 1

func _on_prev_button_pressed():
	current_image_index = max(0, current_image_index - 1)
	update_gallery()

func _on_next_button_pressed():
	current_image_index = min(image_paths.size() - 1, current_image_index + 1)
	update_gallery()

func _on_back_button_pressed():
	# Cambia esto por la escena a la que quieres volver
	get_tree().change_scene_to_file("res://tu_menu_principal.tscn")
