SWEP.PrintName = g_handcuff_lang().PrintName
SWEP.Author = "Guillaume"
SWEP.Category = "Handcuffs"
SWEP.Instructions = g_handcuff_lang().Instructions
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
SWEP.R_Time = 0
SWEP.DraggingPlayer = nil

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
		if not ent:IsPlayer() then return end 
		if Distance(ply, ent, 100) then
			if not IsCuffed(ent) then
				ply:PrintMessage(4, "...")
				ent:Freeze(true)
				timer.Simple(5, function()
					if HasCuffsInHand(ply) then
						Handcuff(ent, ply)
						ent:Freeze(false)
					end 
				end)
			else
				ply:PrintMessage(4, "...")
				ent:Freeze(true)
				timer.Simple(5, function()
					if HasCuffsInHand(ply) then
						RemoveHandcuff(ent, ply)
						ent:Freeze(false)
					end
				end)			
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if CurTime() <= self.R_Time then return end
	
	local ply = self.Owner
	local other_ply = ply:GetEyeTrace().Entity

	if other_ply:IsVehicle() and self.DraggingPlayer:IsPlayer() then
		if self.DraggingPlayer:InVehicle() then return end
		self.R_Time = CurTime() + 0.3
		PutInCar(self.DraggingPlayer, other_ply)
	elseif other_ply:IsVehicle() and self.DraggingPlayer:IsPlayer() then
		if not self.DraggingPlayer:InVehicle() then return end
		self.R_Time = CurTime() + 0.3
		ReturnFromCar(self.DraggingPlayer, other_ply)
	end
	if not other_ply:IsPlayer() then return end
	if not IsCuffed(other_ply) then return end
	
	local timer_name = ply:SteamID().."_BeingFollowedBy"..other_ply:SteamID()

	if not timer.Exists(timer_name) then
		self.R_Time = CurTime() + 0.3
		ply:PrintMessage(4, other_ply:Nick().." is now following you")
		timer.Create(timer_name, 0, 0, function()
			if not ply:Alive() or not other_ply:Alive() or not IsCuffed(other_ply) or other_ply:isArrested() then 
				self.DraggingPlayer = nil
				timer.Remove(timer_name)
			end
			self.DraggingPlayer = other_ply
			FollowCuffer(ply, other_ply)
		end)
	else
		self.R_Time = CurTime() + 0.3
		timer.Remove(timer_name)
		self.DraggingPlayer = nil
		ply:PrintMessage(4, other_ply:Nick().." is not following anymore")
	end
end

function SWEP:Reload()
	if CLIENT then return end
end
