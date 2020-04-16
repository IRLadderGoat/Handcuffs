--#NoSimplerr#

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("Jailermenu")
util.AddNetworkString("Jailplayer")


function ENT:Initialize()
	self:SetModel( "models/mossman.mdl" )
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()    
end

function ENT:AcceptInput(name, activator, caller)
    if name == "Use" and IsValid(caller) then
        
		--> Variables
		local nbyPlayers = {} 
		nbyPlayers = GetNearbyPlayers(activator) 
		--PrintTable(nbyPlayers)

		if table.IsEmpty(nbyPlayers) then 
			DarkRP.notify(activator, 3, 4, "No nearby handcuffed players")
			return
		end
		net.Start("Jailermenu")
			net.WriteTable(nbyPlayers)
		net.Send(caller)
    end
end

function GetNearbyPlayers(ply)
	local nbyPlayers = {}
	local count = 0
	local allplayers = player.GetAll()
	for k, v in pairs( allplayers ) do	
		if v:isArrested() == nil and IsCuffed(v) then 
			if v:GetPos():Distance(ply:GetPos()) < 500 and v ~= ply then
				count = count+1
            	table.insert(nbyPlayers, count, v)
			end
		end
	end
	return nbyPlayers
end

function JailPlayer()
	local ply_steamid = net.ReadString()
	local jailer_steamid = net.ReadString()
	local jailtime = net.ReadUInt(32)

	local ply = player.GetBySteamID(ply_steamid)
	local jailer = player.GetBySteamID(jailer_steamid)

	ply:arrest(jailtime*60, jailer)
end
net.Receive("Jailplayer", JailPlayer)
