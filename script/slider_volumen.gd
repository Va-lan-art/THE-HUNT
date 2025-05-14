# SliderVolumen.gd
extends HSlider

func _ready():
	value = SonidoGlobal.volumen_maestro * 100
	value_changed.connect(_on_value_changed)

func _on_value_changed(valor: float):
	SonidoGlobal.cambiar_volumen(valor / 100.0)
