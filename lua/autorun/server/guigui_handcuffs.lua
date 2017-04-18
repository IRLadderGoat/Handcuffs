CreateConVar("Handcuffs_StrictWeapons", "0", {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED }, "Strict weapons")

function Handcuff(ent, ply)
	if ent:GetActiveWeapon():GetClass() == "guigui_handcuffed" then return end 
	if ent:IsValid() and ent:IsPlayer() then
		ent:Give("guigui_handcuffed")
		ent:SelectWeapon("guigui_handcuffed")
		local speed = ent:GetWalkSpeed()/2
		ent:SetWalkSpeed(speed)
		ent:SetRunSpeed(speed)
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(20, 8.8, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(15, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 75))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(-15, 0, 0))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, -75))
		ent:ManipulateBoneAngles(ent:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(-20, 16.6, 0))
		ent:EmitSound("vehicles/atv_ammo_close.wav", 100, 255)	
		if ply then
			ply:PrintMessage(4, guigui_handcuff_lang().Cuffed)
			print(ply:GetName().." ("..ply:SteamID()..") handcuffed "..ent:GetName().." ("..ent:SteamID()..").")
		end	
	end
end

function RemoveHandcuff(ent, ply, lockpick)
	local wep = ent:GetActiveWeapon():GetClass()
	if wep == "guigui_handcuffed" then
		ent:StripWeapon("guigui_handcuffed")
		local speed = ent:GetWalkSpeed()*2
		ent:SetWalkSpeed(speed)
		ent:SetRunSpeed(speed)
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
				ply:PrintMessage(4, guigui_handcuff_lang().Uncuffed)
				print(ply:GetName().." ("..ply:SteamID()..") lockpick "..ent:GetName().." ("..ent:SteamID()..") handcuffs.")
			else
				ply:PrintMessage(4, guigui_handcuff_lang().Uncuffed)
				print(ply:GetName().." ("..ply:SteamID()..") removed "..ent:GetName().." ("..ent:SteamID()..") handcuffs.")
			end
		end
	end
end

hook.Add("PlayerSwitchWeapon", "Handcuffs", function(ply)
	if ply:HasWeapon("guigui_handcuffed") then
		timer.Simple(0, function() ply:SelectWeapon("guigui_handcuffed") end)
	end
	end)

hook.Add("PlayerDeath", "Handcuffs_death", function(ply)
	if ply:HasWeapon("guigui_handcuffed") then
		ply:StripWeapon("guigui_handcuffed")
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