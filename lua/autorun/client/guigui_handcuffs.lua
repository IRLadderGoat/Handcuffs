surface.CreateFont("HandcuffsHUD", { font = "Arial", 
	size = 50, 
	antialias = true, 
	weight = 750, 
	shadow = true
})

surface.CreateFont("HandcuffsDraw", {
	font = "Arial", 
	size = 25, 
	antialias = true, 
	weight = 750, 
	shadow = true
})

hook.Add("PostDrawHUD", "HandcuffsHUD", function()
	local ply = LocalPlayer()
	if ply:HasWeapon("guigui_handcuffed") then
		if !ply:Alive() then return end
		draw.DrawText(guigui_handcuff_lang().Handcuffed, "HandcuffsHUD", ScrW()/2, ScrH()/1.08, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end
end)

hook.Add("PostPlayerDraw", "HandcuffsDraw", function(ply)
	if GetConVar("Handcuffs_ShowHeadText"):GetString() == "1" then
		if ply:HasWeapon("guigui_handcuffed") then
			if !ply:Alive() then return end
			local offset = Vector(0, 0, 85)
			local ang = LocalPlayer():EyeAngles()
			local pos = ply:GetPos() + offset + ang:Up()
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)
			cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
				draw.DrawText(guigui_handcuff_lang().Handcuffed, "HandcuffsDraw", 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end)