extends HSlider
# Este script se encarga de estilizar un HSlider para el volumen del sonido

# Define los colores que mencionaste
var light_cream = Color.from_string("E7DCD7", Color()) # rgb(231, 220, 215)
var mid_brown = Color.from_string("8E3710", Color())   # rgb(142, 55, 16)
var dark_brown = Color.from_string("2A1005", Color())  # rgb(42, 16, 5)

# Colores para highlights (puedes ajustarlos)
var mid_brown_highlight = mid_brown.lightened(0.2)
var light_cream_highlight = light_cream.lightened(0.1)


func _ready():
	# Configuración inicial del valor y conexión de señal
	if SonidoGlobal: # Asegurarse que SonidoGlobal existe
		value = SonidoGlobal.volumen_maestro * 100
	else:
		printerr("SonidoGlobal no encontrado. El valor del Slider no se inicializará correctamente.")
		value = 50 # Valor por defecto si SonidoGlobal no está
		
	value_changed.connect(_on_value_changed)

	# Aplicar estilos por código
	apply_custom_styles()

func apply_custom_styles():
	var bar_vertical_padding = 4 # Píxeles de padding arriba y abajo para la barra, define su "grosor" visible
	var grabber_diameter = 20 # Diámetro deseado del círculo del grabber

	# Estilo para el fondo del slider (la barra principal)
	var slider_style = StyleBoxFlat.new()
	slider_style.bg_color = dark_brown
	slider_style.set_corner_radius_all(5)
	slider_style.content_margin_top = bar_vertical_padding 
	slider_style.content_margin_bottom = bar_vertical_padding
	add_theme_stylebox_override("slider", slider_style)

	# Estilo para el área de progreso (la parte rellena)
	var grabber_area_style = StyleBoxFlat.new()
	grabber_area_style.bg_color = mid_brown
	grabber_area_style.set_corner_radius_all(5)
	grabber_area_style.content_margin_top = bar_vertical_padding 
	grabber_area_style.content_margin_bottom = bar_vertical_padding
	add_theme_stylebox_override("grabber_area", grabber_area_style)
	
	# Estilo para el área de progreso cuando está resaltada (hover)
	var grabber_area_highlight_style = StyleBoxFlat.new()
	grabber_area_highlight_style.bg_color = mid_brown_highlight
	grabber_area_highlight_style.set_corner_radius_all(5)
	grabber_area_highlight_style.content_margin_top = bar_vertical_padding
	grabber_area_highlight_style.content_margin_bottom = bar_vertical_padding
	add_theme_stylebox_override("grabber_area_highlight", grabber_area_highlight_style)

	# Estilo para el "grabber" (el círculo o tirador)
	var grabber_icon_style = StyleBoxFlat.new()
	grabber_icon_style.bg_color = light_cream
	grabber_icon_style.set_corner_radius_all(grabber_diameter / 2) # Para hacerlo circular
	grabber_icon_style.border_width_bottom = 1
	grabber_icon_style.border_width_left = 1
	grabber_icon_style.border_width_right = 1
	grabber_icon_style.border_width_top = 1
	grabber_icon_style.border_color = dark_brown
	# Usar expand_margin para dar tamaño al StyleBoxFlat cuando se usa como icono
	# Esto define el tamaño total del icono.
	grabber_icon_style.expand_margin_left = grabber_diameter / 2.0
	grabber_icon_style.expand_margin_right = grabber_diameter / 2.0
	grabber_icon_style.expand_margin_top = grabber_diameter / 2.0
	grabber_icon_style.expand_margin_bottom = grabber_diameter / 2.0
	add_theme_icon_override("grabber", grabber_icon_style)
	
	# Estilo para el "grabber" resaltado
	var grabber_icon_highlight_style = StyleBoxFlat.new()
	grabber_icon_highlight_style.bg_color = light_cream_highlight
	grabber_icon_highlight_style.set_corner_radius_all(grabber_diameter / 2)
	grabber_icon_highlight_style.border_width_bottom = 1
	grabber_icon_highlight_style.border_width_left = 1
	grabber_icon_highlight_style.border_width_right = 1
	grabber_icon_highlight_style.border_width_top = 1
	grabber_icon_highlight_style.border_color = mid_brown
	grabber_icon_highlight_style.expand_margin_left = grabber_diameter / 2.0
	grabber_icon_highlight_style.expand_margin_right = grabber_diameter / 2.0
	grabber_icon_highlight_style.expand_margin_top = grabber_diameter / 2.0
	grabber_icon_highlight_style.expand_margin_bottom = grabber_diameter / 2.0
	add_theme_icon_override("grabber_highlight", grabber_icon_highlight_style)
	
	# Asegurar que el HSlider tenga una altura mínima para mostrar los estilos.
	# La altura debe ser al menos el diámetro del grabber o el grosor de la barra.
	var min_slider_height = max(grabber_diameter, bar_vertical_padding * 2 + 4) # +4 para un poco de espacio extra
	if custom_minimum_size.y < min_slider_height:
		custom_minimum_size.y = min_slider_height
	
	# Si el slider está en un contenedor (ej. VBoxContainer, HBoxContainer),
	# asegúrate que sus `size_flags_vertical` le permitan tener esta altura.
	# Por ejemplo, si está solo, `custom_minimum_size.y` es clave.
	# Si está en un VBoxContainer, `size_flags_vertical = SIZE_SHRINK_CENTER` o `SIZE_SHRINK_BEGIN/END`
	# podría ser necesario si quieres que tome esta altura mínima en lugar de expandirse.

func _on_value_changed(valor: float):
	if SonidoGlobal:
		SonidoGlobal.cambiar_volumen(valor / 100.0)
