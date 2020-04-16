CreateConVar("Handcuffs_StrictWeapons", "0", {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Strict weapons")

function Handcuff(ent, ply)
	if IsCuffed(ent) then return false
	if ent:IsValid() and ent:IsPlayer() then
		ent:Give("g_handcuffed")
		ent:SelectWeapon("g_handcuffed")
		local WalkSpeed = ent:GetWalkSpeed()/2
		ent:SetWalkSpeed(WalkSpeed)
		ent:SetRunSpeed(WalkSpeed)
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(20, 8.8, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(15, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 75))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-15, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, -75))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(-20, 16.6, 0))
		ent:EmitSound("vehicles/atv_ammo_close.wav", 100, 255)	
		if ply then
			ply:PrintMessage(4, g_handcuff_lang().Cuffed)
			print(ply:GetName().." ("..ply:SteamID()..") handcuffed "..ent:GetName().." ("..ent:SteamID()..").")
		end	
	end
end

function RemoveHandcuff(ent, ply, lockpick)

	if IsCuffed(ent) then
		ent:StripWeapon("g_handcuffed")
		local WalkSpeed = ent:GetWalkSpeed()*2
		local RunSpeed = ply:GetRunSpeed()
		ent:SetWalkSpeed(WalkSpeed)
		ent:SetRunSpeed(RunSpeed)
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
		if lockpick then
			ent:EmitSound("physics/metal/metal_box_break1.wav", 100, 150)
		else
			ent:EmitSound("vehicles/atv_ammo_open.wav", 100, 255)
		end
		if ply then
			if lockpick then
				ply:PrintMessage(4, g_handcuff_lang().Uncuffed)
				print(ply:GetName().." ("..ply:SteamID()..") lockpick "..ent:GetName().." ("..ent:SteamID()..") handcuffs.")
			else
				ply:PrintMessage(4, g_handcuff_lang().Uncuffed)
				print(ply:GetName().." ("..ply:SteamID()..") removed "..ent:GetName().." ("..ent:SteamID()..") handcuffs.")
			end
		end
	end
end

function FollowCuffer(ply, other_ply)
	local ply_vec = ply:GetPos()
	local other_ply_vec = other_ply:GetPos()
	local ply_ang = (ply_vec - other_ply:GetShootPos()):Angle()
	local distance_vec = other_ply_vec:Distance(ply_vec)
	if distance_vec < 300 and distance_vec >= 100 then 
		other_ply:SetEyeAngles(ply_ang + Angle(-35,0,0))
		other_ply:SetVelocity(ply_vec - other_ply_vec)
	end
end

function PutInCar(ply, vehicle)
	local available_seats = vehicle:VC_getSeatsAvailable()
	if #available_seats <= 1 then return end
	for k, v in pairs(available_seats) do
		if not v:GetDriver():IsValid() and k ~= 1 then
			ply:EnterVehicle(v)
			ply:Freeze(true)
			return
		end
	end
end

function ReturnFromCar(ply, vehicle)
	ply:ExitVehicle()
	ply:Freeze(false)
end

function IsCuffed(ply)
	if ply:GetActiveWeapon():GetClass() == "g_handcuffed" then
		return true
	elseif ply:GetActiveWeapon():GetClass() ~= "g_handcuffed" then
		return false
	end
end

function HasCuffsInHand(ply)
	if ply:GetActiveWeapon():GetClass() == "g_handcuffs" then
		return true
	else
		return false
	end
end

function Distance(ply, ent, dist)
	return ply:GetPos():DistToSqr(ent:GetPos()) < (dist*dist)
end

hook.Add("PlayerSwitchWeapon", "Handcuffs", function(ply)
	if ply:HasWeapon("g_handcuffed") then
		timer.Simple(0, function() ply:SelectWeapon("g_handcuffed") end)
	end
end)


hook.Add("PlayerDeath", "Handcuffs_death", function(ply)
	if ply:HasWeapon("g_handcuffed") then
		ply:StripWeapon("g_handcuffed")
		local speed = ply:GetWalkSpeed()*2
		ply:SetWalkSpeed(speed)
		ply:SetRunSpeed(speed)
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))
		ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
	end
end)