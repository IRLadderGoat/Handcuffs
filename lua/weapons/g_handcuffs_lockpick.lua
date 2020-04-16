SWEP.PrintName = g_handcuff_lang().PrintName_Lockpick
SWEP.Author = "Guillaume"
SWEP.Category = "Handcuffs"
SWEP.Instructions = g_handcuff_lang().Instructions_Lockpick
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
SWEP.Instructions = "Left Click: Restrain/Release. \nRight Click: Force Players in and out of vehicle."

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
	if CLIENT then return end
	local ply = self.Owner
	local ent = ply:GetEyeTrace().Entity
	if Distance(ply, ent, 50) and ent:IsPlayer() then
		if IsCuffed(ent) then
			ply:PrintMessage(4, "...")
			timer.Simple(2, function() 
				if Distance(ply, ent, 50) then
					RemoveHandcuff(ent, ply, 1) 
					ply:StripWeapon("g_handcuffs_lockpick") 
				end 
			end)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end