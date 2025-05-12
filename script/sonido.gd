extends 2D Node

func _ready():
	Sonido.registrar_musica($"MUSICA FONDO")
	if Sonido.esta_activo():
		$"MUSICA FONDO".play()
