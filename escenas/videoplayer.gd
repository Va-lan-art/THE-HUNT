extends Control

@onready var video_player: VideoStreamPlayer = $MainVBox/VideoFrame/VideoStreamPlayer

var video_files: Array[String] = [
	"res://assets/videos/cat.ogv"
]
var current_video_index: int = 0
var video_to_play_on_load: String = ""


func _ready() -> void:
	if get_node_or_null("MainVBox") == null:
		printerr("ERROR: Node 'MainVBox' not found as a direct child of this node (", name, ").")
	else:
		print("SUCCESS: 'MainVBox' found as a child of '", name, "'.")
		if get_node_or_null("MainVBox/VideoFrame") == null:
			printerr("ERROR: Node 'VideoFrame' not found as a child of 'MainVBox'.")
		else:
			print("SUCCESS: 'MainVBox/VideoFrame' found.")
			if get_node_or_null("MainVBox/VideoFrame/VideoStreamPlayer") == null:
				printerr("ERROR: Node 'VideoStreamPlayer' not found as a child of 'MainVBox/VideoFrame'.")
			else:
				print("SUCCESS: 'MainVBox/VideoFrame/VideoStreamPlayer' found.")

	if video_player == null:
		printerr("ERROR: video_player variable is NULL. Path $MainVBox/VideoFrame/VideoStreamPlayer is likely incorrect or node missing.")
	else:
		print("SUCCESS: video_player variable is assigned.")

	if video_files.is_empty():
		printerr("No video files configured in videoplayer.gd")
		return

	var initial_index_to_play = 0
	if not video_to_play_on_load.is_empty():
		var specific_index = video_files.find(video_to_play_on_load)
		if specific_index != -1:
			initial_index_to_play = specific_index
		else:
			printerr("Requested video not found: ", video_to_play_on_load, ". Playing first video instead.")
	
	if not is_instance_valid(video_player):
		printerr("Cannot load video because video_player node is not valid.")
		return

	load_and_play_video(initial_index_to_play)
	
	if is_instance_valid(video_player):
		if not video_player.is_connected("finished", Callable(self, "_on_video_finished")):
			video_player.finished.connect(_on_video_finished)


func load_and_play_video(index: int) -> void:
	if not is_instance_valid(video_player):
		printerr("load_and_play_video: video_player is null.")
		return

	if index < 0 or index >= video_files.size():
		printerr("Video index out of bounds: ", index)
		return

	current_video_index = index
	var video_path: String = video_files[current_video_index]
	
	var stream = load(video_path) as VideoStream
	if stream:
		video_player.stream = stream
		video_player.play()
	else:
		printerr("Failed to load video: ", video_path)

func _on_video_finished() -> void:
	if current_video_index >= 0 and current_video_index < video_files.size():
		print("Video finished: ", video_files[current_video_index])
	else:
		print("Video finished, but current_video_index seems out of bounds.")
