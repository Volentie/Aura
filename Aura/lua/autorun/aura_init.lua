Aura = Aura or {}

Aura.Version = "0.6"
Aura.ColorServer = Color(120,120,255)
Aura.ColorClient = Color(200,0,200)
Aura.ColorError = Color(255,0,0)
Aura.ColorText = Color(240,240,240)

function Aura:DebugPrint(...)
	local tab = {...}
	local msg = ""
	local col = ...
	for k, v in pairs(tab) do
	local part
		if type(v) == "table" then
			if v.r and v.g and v.b and v.a then
				col = v
				continue -- If not continue the loop, the debug will print the table color in string consequently.
			end
		elseif type(v) == "Entity" then
			if v:IsPlayer() and IsValid(v) then
				part = v:Nick()
			elseif IsValid(v) then
				part = v:GetName() or v:Name()
			end
		end
		part = tostring(v)
		msg = msg .. part
	end
	msg = msg .. "\n"
	MsgC(SERVER and Aura.ColorServer or CLIENT and Aura.ColorClient,"[Aura" .. " " .. Aura.Version .. "] " )
	MsgC(col or Color(255,255,255),msg)
end

function Aura:Error(...)
	local tab = {...}
	local msg = ""
	for k, v in pairs(tab) do
	local part
		part = tostring(v)
		msg = msg .. part
	end
	msg = msg .. "\n"
	MsgC(SERVER and Aura.ColorError or CLIENT and Aura.ColorError,"[Aura" .. " " .. Aura.Version .. "] ERROR: " )
	MsgC(Aura.ColorError,msg)
end

function Aura:Init(switch)
	local switch = tobool(switch)
	if switch == true then
		Aura:DebugPrint(Color(0,255,0),"Aura initialized @ " .. Aura.Version)
		return true
	else
		return false
	end
end

function Aura:IncludeFile(folder,fil,runtype)
	local path = "Aura/"
	path = path .. folder .. "/" .. fil
	if not runtype then
		runtype = string.Left(fil,2) 
	end
	if runtype == "cl" then
		AddCSLuaFile(path)
	elseif runtype == "sv" then
		AddCSLuaFile(path)
		include(path)
	elseif runtype == "sh" then
		AddCSLuaFile(path)
		include(path)
	end
	Aura:DebugPrint(Aura.ColorText,"Loading... " .. folder .. "/" .. fil)
end

function Aura:IncludeFolder(folder,runtype)
		Aura:DebugPrint(Aura.ColorText,"Initializing " .. folder)
	for k, v in pairs(file.Find("Aura/" .. folder .. "/*.lua","LUA")) do
		Aura:IncludeFile(folder,v,runtype)
	end
end

Aura:Init(true) 
Aura:IncludeFolder("core","sh")
Aura:IncludeFolder("util")
Aura:IncludeFolder("plugins","sv")
Aura:IncludeFolder("vgui","cl") 
