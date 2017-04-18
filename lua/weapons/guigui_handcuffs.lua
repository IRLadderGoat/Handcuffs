SWEP.PrintName = guigui_handcuff_lang().PrintName
SWEP.Author = "Guillaume"
SWEP.Category = "Guillaume's weapons"
SWEP.Instructions = guigui_handcuff_lang().Instructions
SWEP.Contact = "steamcommunity.com/id/guillaume_"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.ViewModelFOV = 62
SWEP.WorldModel = ""
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic  = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	return true
end

function SWEP:PreDrawViewModel()
	return true
end

function SWEP:PrimaryAttack()
	if SERVER then 
		local ply = self.Owner
		local ent = ply:GetEyeTrace().Entity
		if ply:GetPos():DistToSqr(ent:GetPos())<2500 then
			local wep = ent:GetActiveWeapon():GetClass()
			if wep == "guigui_handcuffed" then return false end
			if guigui_handcuff_wep(wep) then
				ply:PrintMessage(4, "...")
				timer.Simple(2, function() if ply:GetPos():DistToSqr(ent:GetPos())<2500 and ply:GetActiveWeapon():GetClass() == "guigui_handcuffs" then Handcuff(ent, ply) end end)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	local ply = self.Owner
	local ent = ply:GetEyeTrace().Entity
	if ply:GetPos():DistToSqr(ent:GetPos())<2500 then
		if ent:IsValid() and ent:IsPlayer() then
			local wep = ent:GetActiveWeapon():GetClass()
			if wep == "guigui_handcuffed" then
				ply:PrintMessage(4, "...")
				timer.Simple(2, function() if ply:GetPos():DistToSqr(ent:GetPos())<2500 and ply:GetActiveWeapon():GetClass() == "guigui_handcuffs" then RemoveHandcuff(ent, ply) end end)
			end
		end
	end
end

function SWEP:Reload()
end