shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	// Sombra debajo del papel
	vec2 shadow_offset = vec2(0.02, 0.02);
	vec4 shadow_color = vec4(0.0, 0.0, 0.0, 0.3);
	
	if (color.a > 0.0) {
		COLOR = color;
	} else {
		// Si el píxel es transparente, dibujamos la sombra
		vec4 tex_at_shadow = texture(TEXTURE, UV - shadow_offset);
		if (tex_at_shadow.a > 0.0) {
			COLOR = shadow_color;
		} else {
			COLOR = vec4(0.0);
		}
	}
}extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
