# BotonMute.gd
extends TextureButton

@export var icono_on: Texture2D = preload("res://assets/sonidojuegoon.png")  
@export var icono_off: Texture2D = preload("res://assets/sonidojuegooff.png")  

func _ready():
	actualizar_icono()
	pressed.connect(_on_pressed) 

func _on_pressed():
	SonidoGlobal.alternar_mute()  
	actualizar_icono()

func actualizar_icono():
	texture_normal = icono_off if SonidoGlobal.esta_muteado else icono_on 
