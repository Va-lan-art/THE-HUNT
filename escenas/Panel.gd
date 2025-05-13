extends Panel

func configurar(textura: Texture2D):
	$TextureRect.texture = textura

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		queue_free()
