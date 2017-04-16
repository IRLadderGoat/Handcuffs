Handcuffs = Handcuffs or {}

Handcuffs.lang = GetConVar("gmod_language"):GetString()

function guigui_handcuff_lang()
	for k, v in pairs(Handcuffs.langTable) do
		if k == Handcuffs.lang then
			return v
		end
	end
	return Handcuffs.langTable.en
end

Handcuffs.langTable = {
	["fr"] = {
		["PrintName"] = "Menottes", 
		["Instructions"] = "Clic gauche pour menotter\nClic droit pour demenotter",
		["PrintName_Lockpick"] = "Pince coupante pour menottes",
		["Instructions_Lockpick"] = "Clic gauche pour casser les menottes", 
		["Cuffed"] = "Menotté", 
		["Uncuffed"] = "Demenotté", 
		["Handcuffed"] = "MENOTTÉ"
	}, 
	["en"] = {
		["PrintName"] = "Handcuffs", 
		["Instructions"] = "Left click to cuffed\nRight click to uncuffed", 
		["PrintName_Lockpick"] = "Handcuffs lockpick", 
		["Instructions_Lockpick"] = "Left click to break handcuffs", 
		["Cuffed"] = "Cuffed", 
		["Uncuffed"] = "Unuffed", 
		["Handcuffed"] = "HANDCUFFED"
	}
}