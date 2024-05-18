extends Node

var textures = {}

func _ready():
	preload_textures()

func preload_textures():
	textures["CardFrame"] = preload("res://assets/card_frames/card_frame.png")
	textures["CardFrame5"] = preload("res://assets/card_frames/card_frame_5.png")
	textures["WyndhavenEnclave"] = preload("res://assets/card_art/WyndhavenEnclave.png")
	textures["RuthlessBaronesse"] = preload("res://assets/card_art/RuthlessBaronesse.png")
	textures["UndergroundKingpin"] = preload("res://assets/card_art/UndergroundKingpin.png")
	textures["CrownsSecretkeeper"] = preload("res://assets/card_art/CrownsSecretkeeper.png")
	textures["ForgeboundSmith"] = preload("res://assets/card_art/ForgeboundSmith.png")
	textures["GuildEnforcer"] = preload("res://assets/card_art/GuildEnforcer.png")
	textures["PlagueDoctor"] = preload("res://assets/card_art/PlagueDoctor.png")
	# Add more textures as needed
