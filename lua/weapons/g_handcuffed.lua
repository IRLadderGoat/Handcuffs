SWEP.PrintName = g_handcuff_lang().PrintName
SWEP.Author = "Guillaume"
SWEP.Category = "Handcuffs"
SWEP.Contact = "steamcommunity.com/id/guillaume_"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Spawnable = false
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
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.Instructions = ""


function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:Holster()
	return false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

if CLIENT then
function SWEP:DrawHUD()
    if !LocalPlayer():Alive() then return end
	draw.DrawText(g_handcuff_lang().Handcuffed, "HandcuffsHUD", ScrW()/2, ScrH()/1.08, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end
end
