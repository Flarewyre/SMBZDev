extends Node2D

func _ready():
	if Conductor.MusicStream.stream.resource_path != "res://Assets/Music/galleryMenu.ogg":
		Conductor.play_song("res://Assets/Music/galleryMenu.ogg", 102, 1)
