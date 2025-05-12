extends Node


# Señal para notificar cambios
signal music_state_changed(scene_name, is_active)

var music_players = {}
var music_states = {}

func register_music(scene_name: String, player: AudioStreamPlayer):
	music_players[scene_name] = player
	if not music_states.has(scene_name):
		music_states[scene_name] = true
	player.playing = music_states[scene_name]
	emit_signal("music_state_changed", scene_name, music_states[scene_name])

func toggle_scene_music(scene_name: String):
	if music_players.has(scene_name):
		music_states[scene_name] = !music_states[scene_name]
		music_players[scene_name].playing = music_states[scene_name]
		save_settings()
		emit_signal("music_state_changed", scene_name, music_states[scene_name])

func save_settings():
	var file = ConfigFile.new()
	for scene in music_states:
		file.set_value("music", scene, music_states[scene])
	file.save("user://music_settings.cfg")

func load_settings():
	var file = ConfigFile.new()
	if file.load("user://music_settings.cfg") == OK:
		for scene in file.get_section_keys("music"):
			music_states[scene] = file.get_value("music", scene, true)
