--#NoSimplerr#

include('shared.lua')

/*---------------------------------------------------------
   Name: Draw
   Desc: Draw it!
---------------------------------------------------------*/
function ENT:Draw()
	self:DrawModel()
end

--[[---------------------------------------------------------
	Fonts
-----------------------------------------------------------]]
for i=0,24 do

	--> Size
	local size = 10+i

	--> Font
	surface.CreateFont("TCBDealer_"..size, {
		font = "Trebuchet24",
		size = size,
	})

end

--[[---------------------------------------------------------
	Convars
-----------------------------------------------------------]]
CreateClientConVar("tcb_cardealer_r", 0, true, true)
CreateClientConVar("tcb_cardealer_g", 0, true, true)
CreateClientConVar("tcb_cardealer_b", 0, true, true)

--[[---------------------------------------------------------
	Chat Text
-----------------------------------------------------------]]
local function chatText()
	chat.AddText(Color(52, 152, 219), "[Dealer]", Color(255, 255, 255), " "..net.ReadString())
end
net.Receive("TCBDealerChat", chatText)


--[[---------------------------------------------------------
	Derma Blur - Credits: Mrkrabz
-----------------------------------------------------------]]
local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

--[[---------------------------------------------------------
	Dealer Menu
-----------------------------------------------------------]]
local function carDealer()

	--> Variables
	local vehiclesTable = net.ReadTable()
	local ownedTable 	= vehiclesTable

	--local dealerID = net.ReadInt(32)

	local w = 450
	local h = 602

	--> Frame
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW()/2-w/2, ScrH())
	frame:SetSize(w, h)
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame:MoveTo(ScrW()/2-w/2, ScrH()/2-h/2, 0.2, 0, -1)
	
	frame.Paint = function(pnl, w, h)

		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
		draw.RoundedBox(0, 1, 1, w-2, h-2, Color(255, 255, 255, 255))

		draw.RoundedBox(0, 1, 1, w-2, 40, Color(63, 81, 181, 255))
		draw.SimpleText("Jailer", "TCBDealer_24", 11, 41-20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	end

	--> Close
	local close = vgui.Create("DButton", frame)
	close:SetPos(w-65-7, 41/2-24/2)
	close:SetSize(65, 26)
	close:SetText("")

	close.DoClick = function()

		frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
			frame:Remove()
		end)

	end

	close.Paint = function(pnl, w, h)

		draw.RoundedBox(3, 0, 0, w, h, Color(244, 67, 54, 255))
		draw.SimpleText("x", "TCBDealer_24", w/2, h/2-1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if close.Hovered then
			draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
		end

	end

	--> Color Picker

	--> Panel
	local panel = vgui.Create("DScrollPanel", frame)
	panel:SetPos(1, 41)
	panel:SetSize(w-2, h-2-40)

	panel.VBar.Paint 			= function( pnl, w, h ) draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 50) ) end 
	panel.VBar.btnUp.Paint 		= function( pnl, w, h ) draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 25 ) ) draw.DrawText( "▲", "HudHintTextSmall", 3, 2, Color( 255, 255, 255, 255 ) ) end
	panel.VBar.btnDown.Paint 	= function( pnl, w, h ) draw.RoundedBox( 0, 2, 2, w - 4, h - 4, Color( 0, 0, 0, 25 ) ) draw.DrawText( "▼", "HudHintTextSmall", 3, 2, Color( 255, 255, 255, 255 ) ) end
	panel.VBar.btnGrip.Paint 	= function( pnl, w, h ) draw.RoundedBox( 4, 3, 2, w - 6, h - 4, Color( 63, 81, 181, 255 ) ) end

	--> Slide EWW :(
	local slide = vgui.Create("DPanel", panel)
	slide:SetPos(0, 0)
	slide:SetSize(1, panel:GetTall()+1)

	--> Store
   local posY = 0
	--> Vehicles
	local count = 0
	for k,v in SortedPairs(vehiclesTable, true) do

		--> Count
		count = count+1;

		--> Vehicle Info
		--local vehicleInfo = {}
		--if !v.name or !v.mdl then
		--	vehicleInfo = list.Get("Vehicles")[k]
		--	if !vehicleInfo then continue end
		--end

		--local vehName = v.name or vehicleInfo.Name
        --local vehMdl = v.mdl or vehicleInfo.Model
        local vehMdl = v:GetModel()
        local vehName = v:Nick()

		--> Vehicle Panel
		local vehicle = vgui.Create("DPanel", panel)
		vehicle:SetPos(0, posY)
		vehicle:SetSize((w-2)-16, 80)
		vehicle.count = count

		vehicle.Paint = function(pnl, w, h)

			--> Stripe
			if math.mod(vehicle.count, 2) == 0 then
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 15))
			end

			--> Model
			draw.RoundedBox(2, 4, 4, h-8, h-8, Color(0, 0, 0, 40))

			--> Name
			draw.SimpleText(vehName, "TCBDealer_24", w/2-15, 25, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			--> Price
			--draw.SimpleText("Price: "..DarkRP.formatMoney(v.price), "TCBDealer_22", w/2-15, 55, Color(0, 0, 0, 225), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
		end

		--> Model Preview
		local model = vgui.Create("DModelPanel", vehicle)
		model:SetSize(vehicle:GetTall()-8, vehicle:GetTall()-8)
		model:SetPos(4, 4)
		model:SetModel(vehMdl)
		model:SetCamPos(Vector(40, 10, 50))

		--> Slider
		--local slider = vgui.Create("DSlider", vehicle)
		local slider = vgui.Create("DNumSlider", vehicle)
		slider:SetPos(vehicle:GetWide() / 5.2 ,50)
		slider:SetSize(200,10)
		slider:SetMinMax(1,10)
		slider:SetDecimals(0)
		slider:SetValue(5)


		--> Label
		local arresttimeLabel = vgui.Create("DLabel",vehicle)
		arresttimeLabel:SetText("Arrest Time: " .. slider:GetValue() .. "mins")
		arresttimeLabel:SetPos(vehicle:GetWide()-110,50)
		arresttimeLabel:SetSize(100,30)
		arresttimeLabel:SetTextColor(Color(0, 0, 0))
	
		slider.OnValueChanged = function()
			arresttimeLabel:SetText("Arrest Time: " .. math.floor(slider:GetValue()) .. "mins")
		end

		--> Buttons
		if !table.HasValue(ownedTable, k) then

			--> Purchase
			local purchase = vgui.Create("DButton", vehicle)
			purchase:SetSize(100, vehicle:GetTall()/2-6)
			purchase:SetPos(vehicle:GetWide()-104, 4)
			purchase:SetText("")

			purchase.DoClick = function()
				net.Start("Jailplayer")
					net.WriteString(v:SteamID())	
					net.WriteString(LocalPlayer():SteamID())
					net.WriteUInt(slider:GetValue(), 32)
				net.SendToServer(LocalPlayer())

				frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
					frame:Remove()
				end)
			end

			purchase.Paint = function(pnl, w, h)

				draw.RoundedBox(3, 0, 0, w, h, Color(46, 204, 113, 255))
				draw.SimpleText("Jail", "DermaDefaultBold", w/2, h/2-1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if purchase.Hovered then
					draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
				end

			end

			--> Preview
			-- local preview = vgui.Create("DButton", vehicle)
			-- preview:SetSize(100, vehicle:GetTall()/2-6)
			-- preview:SetPos(vehicle:GetWide()-104, purchase:GetTall()+8)
			-- preview:SetText("")

			-- preview.DoClick = function()
			-- 	net.Start("TCBDealerSpawn")
			-- 		net.WriteString(k)
			-- 		--net.WriteInt(dealerID, 32)
			-- 		net.WriteBool(true)
			-- 	net.SendToServer(LocalPlayer())

			-- 	frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
			-- 		frame:Remove()
			-- 	end)
			-- end

			-- preview.Paint = function(pnl, w, h)

			-- 	draw.RoundedBox(3, 0, 0, w, h, Color(52, 152, 219, 255))
			-- 	draw.SimpleText("Test Drive", "DermaDefaultBold", w/2, h/2-1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- 	if preview.Hovered then
			-- 		draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
			-- 	end

			-- end

		else

			--> Spawn
			local spawn = vgui.Create("DButton", vehicle)
			spawn:SetSize(100, vehicle:GetTall()/2-6)
			spawn:SetPos(vehicle:GetWide()-104, 4)
			spawn:SetText("")

			spawn.DoClick = function()
				net.Start("TCBDealerSpawn")
					net.WriteString(k)
					--net.WriteInt(dealerID, 32)
					net.WriteBool(false)
				net.SendToServer(LocalPlayer())

				frame:MoveTo(ScrW()/2-w/2, ScrH(), 0.2, 0, -1, function()
					frame:Remove()
				end)
			end

			spawn.Paint = function(pnl, w, h)

				draw.RoundedBox(3, 0, 0, w, h, Color(46, 204, 113, 255))
				draw.SimpleText("Spawn", "DermaDefaultBold", w/2, h/2-1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				if spawn.Hovered then
					draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 6))
				end

			end

		end

		--> Position
		posY = posY + vehicle:GetTall()

	end

end
net.Receive("Jailermenu", carDealer)