NPC = NPC or {}

NPC.settings = {}
NPC.Jailer = {}
NPC.Bailer = {}

NPC.Jailer.npcSpawns = {}
NPC.Bailer.npcSpawns = {}


NPC.settings.interactDistance = 400
NPC.settings.playerDistance     = 400


NPC.Jailer.npcSpawns["gm_construct"] = {
	{
		pos = Vector(780, -180, -75),
		ang = Angle(0, -90, 0),
		mdl = "models/Characters/Hostage_02.mdl",
	}
}
NPC.Bailer.npcSpawns["gm_construct"] = {
	{
		pos = Vector(700, -180, -75),
		ang = Angle(0, -90, 0),
		mdl = "models/mossman.mdl",
	}
}
