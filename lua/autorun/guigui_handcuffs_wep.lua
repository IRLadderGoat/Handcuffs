Handcuffs = Handcuffs or {}

function guigui_handcuff_wep(wep)
	for k, v in pairs(Handcuffs.wepTable) do
		if k == wep then
			return v
		end
	end
	if GetConVar("Handcuffs_StrictWeapons"):GetString() == "1" then
		return false
	else
		return true
	end
end

Handcuffs.wepTable = {
	["weapon_physgun"] = true, 
	["weapon_physcannon"] = true, 
	["gmod_tool"] = true, 
	["weapon_fists"] = true, 
	["keys"] = true, 
	["pocket"] = true, 
}