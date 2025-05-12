# BotonMute.gd
extends TextureButton

@export var icono_on: Texture2D = preload("res://assets/sonidojuegoon.png")  # Fixed line
@export var icono_off: Texture2D = preload("res://assets/sonidojuegooff.png")  # Fixed line

func _ready():
	actualizar_icono()
	pressed.connect(_on_pressed)  # Fixed signal connection

func _on_pressed():
	SonidoGlobal.alternar_mute()  # Fixed function call
	actualizar_icono()

func actualizar_icono():
	texture_normal = icono_off if SonidoGlobal.esta_muteado else icono_on  # Fixed condition
