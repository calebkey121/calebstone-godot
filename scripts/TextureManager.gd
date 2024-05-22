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
	textures["RuthlessBaroness"] = preload("res://assets/card_art/RuthlessBaroness.png")
	textures["UndergroundKingpin"] = preload("res://assets/card_art/UndergroundKingpin.png")
	textures["CrownsSecretkeeper"] = preload("res://assets/card_art/CrownsSecretkeeper.png")
	textures["ForgeboundSmith"] = preload("res://assets/card_art/ForgeboundSmith.png")
	textures["GuildEnforcer"] = preload("res://assets/card_art/GuildEnforcer.png")
	textures["PlagueDoctor"] = preload("res://assets/card_art/PlagueDoctor.png")
	textures["BanditOutlaw"] = preload("res://assets/card_art/Bandit Outlaw.png")
	textures["BansheesWail"] = preload("res://assets/card_art/Banshee's Wail.png")
	textures["BoneCollector"] = preload("res://assets/card_art/Bone Collector.png")
	textures["BowMarshal"] = preload("res://assets/card_art/Bow Marshal.png")
	textures["CastleWard"] = preload("res://assets/card_art/Castle Ward.png")
	textures["CourtAlchemist"] = preload("res://assets/card_art/Court Alchemist.png")
	textures["CryptCreeper"] = preload("res://assets/card_art/Crypt Creeper.png")
	textures["CursedSquire"] = preload("res://assets/card_art/Cursed Squire.png")
	textures["DireWolf"] = preload("res://assets/card_art/Dire Wolf.png")
	textures["GhoulVanguard"] = preload("res://assets/card_art/Ghoul Vanguard.png")
	textures["GhostlyRaider"] = preload("res://assets/card_art/Ghostly Raider.png")
	textures["GraveyardSentinel"] = preload("res://assets/card_art/Graveyard Sentinel.png")
	textures["HighlandScout"] = preload("res://assets/card_art/Highland Scout.png")
	textures["HighwaymansAmbush"] = preload("res://assets/card_art/Highwayman's Ambush.png")
	textures["JoustingChampion"] = preload("res://assets/card_art/Jousting Champion.png")
	textures["MercenaryCaptain"] = preload("res://assets/card_art/Mercenary Captain.png")
	textures["MournfulSpirit"] = preload("res://assets/card_art/Mournful Spirit.png")
	textures["NecromanceroftheForgottenDepths"] = preload("res://assets/card_art/Necromancer of the Forgotten Depths.png")
	textures["NecromanceroftheVale"] = preload("res://assets/card_art/Necromancer of the Vale.png")
	textures["NecropolisGuard"] = preload("res://assets/card_art/Necropolis Guard.png")
	textures["PhantomSteed"] = preload("res://assets/card_art/Phantom Steed.png")
	textures["RevenantArcher"] = preload("res://assets/card_art/Revenant Archer.png")
	textures["RoyalFalconer"] = preload("res://assets/card_art/Royal Falconer.png")
	textures["ShadowofthePast"] = preload("res://assets/card_art/Shadow of the Past.png")
	textures["SiegeEngineer"] = preload("res://assets/card_art/Siege Engineer.png")
	textures["SkeletalKnight"] = preload("res://assets/card_art/Skeletal Knight.png")
	textures["SpectralFerryman"] = preload("res://assets/card_art/Spectral Ferryman.png")
	textures["TombWarden"] = preload("res://assets/card_art/Tomb Warden.png")
	textures["UndeadCreature"] = preload("res://assets/card_art/Undead Creature.png")
	textures["VillageBlacksmith"] = preload("res://assets/card_art/Village Blacksmith.png")
	textures["WanderingMinstrel"] = preload("res://assets/card_art/Wandering Minstrel.png")
	# Add more textures as needed
	
func get_texture(name):
	if textures.has(name):
		return textures[name]
	else:
		print("Texture not found: ", name)
		return null

