extends Node

var textures = {}

func _ready():
	preload_textures()

func preload_textures():
	textures["card_frame"] = preload("res://assets/card_frames/card_frame.png")
	textures["card_frame_5"] = preload("res://assets/card_frames/card_frame_5.png")
	textures["card_frame_10"] = preload("res://assets/card_frames/card_frame_10.png")
	textures["card_frame_11"] = preload("res://assets/card_frames/card_frame_11.png")
	textures["card_frame_12"] = preload("res://assets/card_frames/card_frame_12.png")
	textures["WyndhavenEnclave"] = preload("res://assets/card_art/WyndhavenEnclave.png")
	textures["RuthlessBaronesse"] = preload("res://assets/card_art/RuthlessBaronesse.png")
	textures["UndergroundKingpin"] = preload("res://assets/card_art/UndergroundKingpin.png")
	textures["CrownsSecretkeeper"] = preload("res://assets/card_art/CrownsSecretkeeper.png")
	textures["ForgeboundSmith"] = preload("res://assets/card_art/ForgeboundSmith.png")
	textures["GuildEnforcer"] = preload("res://assets/card_art/GuildEnforcer.png")
	textures["PlagueDoctor"] = preload("res://assets/card_art/PlagueDoctor.png")
	# Add more textures as needed
	
func get_texture(name):
	return textures.get(name, null)
