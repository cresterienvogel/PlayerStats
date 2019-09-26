include("sh_init.lua")

local scale = 1

local outbreath = Material("crester/playerstats/breath.png", "smooth mips")
local drowning = Material("crester/playerstats/drowning.png", "smooth mips")
local happy = Material("crester/playerstats/hapinness.png", "smooth mips")
local burning = Material("crester/playerstats/burning.png", "smooth mips")
local poison = Material("crester/playerstats/poison.png", "smooth mips")

local furious = Material("crester/playerstats/furious.png", "smooth mips")
local inspired = Material("crester/playerstats/inspired.png", "smooth mips")
local wornout = Material("crester/playerstats/stamina.png", "smooth mips")
local injured = Material("crester/playerstats/injured.png", "smooth mips")

local function AddIcon(color, material, xalign, yalign, a, b)
    surface.SetDrawColor(Color(0, 0, 0, 255))
    surface.SetMaterial(material)
    surface.DrawTexturedRect(xalign, yalign, a, b)

    surface.SetDrawColor(Color(0, 0, 0, 150))
    surface.SetMaterial(material)
    surface.DrawTexturedRect(xalign, yalign, a + 1, b + 1)

    surface.SetDrawColor(color)
    surface.SetMaterial(material)
    surface.DrawTexturedRect(xalign, yalign, a, b)            
end

local function AddBar(w, color, icon, x, y)
	local h = 22 * scale

	AddIcon(color, icon, x, y - h + h / 4, 70, 70)

	return w * scale, h
end

local x, y, smth, seen = 0, 0, 0

local function StatSetting(w, h)
	x = x
	y = y - 20 + w 
	smth = math.max(smth, h)
	seen = true
end

local function space()
	x = x * scale
end

local hud = {}

local function Row(...)
	table.insert(hud, {...})
end

Row(
	function()
    	if LocalPlayer():GetNWBool("isInspired") then
			StatSetting(AddBar(100, HSVToColor(200, math.abs(math.sin(RealTime() * 2)), 1), inspired, x, y))
		end
	end,

	function()
    	if LocalPlayer():IsOnFire() then
			StatSetting(AddBar(100, HSVToColor(0, math.abs(math.sin(RealTime() * 2)), 1), burning, x, y))
		end
	end,

	function()
    	if LocalPlayer():GetNWBool("isPoisoned") then
			StatSetting(AddBar(100, HSVToColor(0, math.abs(math.sin(RealTime() * 2)), 1), poison, x, y))
		end
	end,

	function()
    	if LocalPlayer():GetNWBool("isHappy") then
			StatSetting(AddBar(100, HSVToColor(200, math.abs(math.sin(RealTime() * 2)), 1), happy, x, y))
		end
	end,

	function()
    	if LocalPlayer():GetNWBool("isFurious") then
			StatSetting(AddBar(100, HSVToColor(200, math.abs(math.sin(RealTime() * 2)), 1), furious, x, y))
		end
	end,

	function()
    	if LocalPlayer():GetNWBool("isInjured") then
			StatSetting(AddBar(100, HSVToColor(0, math.abs(math.sin(RealTime() * 2)), 1), injured, x, y))
		end
	end,

	function()
    	if LocalPlayer():GetNWBool("isOutbreath") then
			StatSetting(AddBar(100, HSVToColor(0, math.abs(math.sin(RealTime() * 2)), 1), outbreath, x, y))
		end
	end,

	function()
    	if LocalPlayer():GetNWBool("isDrowning") then
			StatSetting(AddBar(100, HSVToColor(0, math.abs(math.sin(RealTime() * 2)), 1), drowning, x, y))
		end
	end,

	function()
    	if LocalPlayer():GetNWBool("isWornout") then
			StatSetting(AddBar(100, HSVToColor(0, math.abs(math.sin(RealTime() * 2)), 1), wornout, x, y))
		end
	end
)

hook.Add("HUDPaint", "DrawStats", function()
	if not LocalPlayer():Alive() then 
		return 
	end

	local offy, offx = 20, ScrW() - 80
	x, y = offx, offy

	for _, row in pairs(hud) do
		for _, fn in pairs(row) do
			seen = false

			xpcall(fn, Error)
			
			if seen then
				space()
			end
		end
	
		offy = offy - smth
		smth = 0
		
		y = offy
		x = offx
	end
end)