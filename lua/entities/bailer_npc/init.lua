--#NoSimplerr#

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

util.AddNetworkString("Bailermenu")
util.AddNetworkString("Bailplayer")


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
        local nbyPlayers = GetNearbyPlayers(activator) 
		
		if table.IsEmpty(nbyPlayers) then 
			DarkRP.notify(activator, 3, 4, "No nearby players")
			return
		end
		print(#nbyPlayers)
		net.Start("Bailermenu")
			net.WriteTable(nbyPlayers)
		net.Send(caller)
    end
end

function GetNearbyPlayers(ply)
	local nbyPlayers = {}
	local count = 0
	for k, v in pairs( player.GetAll() ) do	
		if v:isArrested() ~= nil then
			count = count+1
           	table.insert(nbyPlayers, count, v)
		end
	end
	return nbyPlayers
end

function Bailplayer()
	local ply_steamid = net.ReadString()
	local bailer_steamid = net.ReadString()
	local ply = player.GetBySteamID(ply_steamid)
	local bailer = player.GetBySteamID(bailer_steamid)

	if bailer:getDarkRPVar("money") > 10000 then
		ply:addMoney(-10000)
		ply:unArrest(bailer)
	else
		DarkRP.notify(bailer, 4, 4, "You don't have enough money to bail out this player")
	end

end
net.Receive("Bailplayer", Bailplayer)