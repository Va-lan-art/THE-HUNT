# Sonido.gd
extends Node

var sonido_activo := true
var musica = null  # Puede ser AudioStreamPlayer2D, AudioStreamPlayer, etc.

func registrar_musica(nodo_musica):
	if nodo_musica.has_method("play") and nodo_musica.has_method("stop"):
		musica = nodo_musica
		if not sonido_activo:
			_aplicar_estado()
	else:
		push_error("El nodo pasado no tiene métodos play() y stop(). Asegúrate de pasar un AudioStreamPlayer válido.")

func alternar_sonido():
	sonido_activo = !sonido_activo
	_aplicar_estado()

func _aplicar_estado():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not sonido_activo)
	if musica:
		if sonido_activo:
			if not musica.playing:
				musica.play()
		else:
			if musica.playing:
				musica.stop()

func esta_activo() -> bool:
	return sonido_activo
