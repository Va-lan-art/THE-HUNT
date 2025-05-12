extends AudioStreamPlayer2D

var sonido_activo := true

func alternar_sonido():
	sonido_activo = !sonido_activo
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not sonido_activo)

func esta_activo() -> bool:
	return sonido_activo
