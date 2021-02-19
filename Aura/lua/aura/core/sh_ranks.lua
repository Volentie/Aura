local RMeta = {}
 
AccessorFunc(RMeta,"simpleName","SimpleName",FORCE_STRING)
AccessorFunc(RMeta,"prettyName","PrettyName",FORCE_STRING)
AccessorFunc(RMeta,"col","Col")
AccessorFunc(RMeta,"tag","Tag",FORCE_STRING)
AccessorFunc(RMeta,"tagCol","TagCol")
AccessorFunc(RMeta,"power","Power",FORCE_NUMBER)



Aura.Ranks = Aura.Ranks or {}
Aura.PlayerRanks = Aura.PlayerRanks or {}

function Aura:CreateRank(simple,pretty,tagcol,tag,col,power)
	local RANK = {}
	setmetatable(RANK,RMeta)
	RMeta.__index = RMeta
	
	RANK:SetSimpleName(simple)
	RANK:SetPrettyName(pretty)
	RANK:SetCol(col)
	RANK:SetTag(tag)
	RANK:SetTagCol(tagcol)
	RANK:SetPower(power)
	
	table.insert(Aura.Ranks,RANK)

	Aura:DebugPrint(Color(255,255,255),"Created rank: " .. pretty .. " (Col:(" .. tostring(col) .. ") / Power: " .. power .. ") " .. tag )
	
	return RANK
end

Aura:CreateRank("user","User",Color(120,140,120),"[User]",Color(156,140,156),0)
Aura:CreateRank("admin","Administrator",Color(51,51,150),"[Admin]",Color(51,51,255),40)
Aura:CreateRank("owner","Owner",Color(200,51,51),"[Owner]",Color(255,51,51),60)

for _,r in ipairs(Aura.Ranks) do
	team.SetUp(_,r:GetSimpleName(),r:GetCol(),true)
end

function Aura:GetPly(s,ply)
	s = string.lower( s )
	if s == "^" then return ply end
	for _, v in pairs( player.GetAll() ) do
		if
			string.find( string.lower( v:Nick() ), s, 1, true ) ~= nil or
			s == v:EntIndex() or
			s == v:SteamID()  or
			s == v:SteamID64()
		then
		   return v
		end
	end
	return false
end

function Aura:SetupRank(ply,rank)
	if IsValid(ply) and ply:IsPlayer() then
		Aura.PlayerRanks[ply:SteamID()] = rank
		Aura:DebugPrint(Color(255,0,255),'Setup rank: ' .. Aura.PlayerRanks[ply:SteamID()] .. ' for ' .. ply:Nick())
	else
		Aura:Error("Invalid player. (Aura:SetupRank() [sh_ranks])")
	end
end

function Aura:GetPlyRank(ply)
	if IsValid(ply) and ply:IsPlayer() then
		for k, v in pairs(Aura.Ranks) do
			if Aura.PlayerRanks[ply:SteamID()] == v:GetSimpleName() or Aura.PlayerRanks[ply:SteamID()] == v:GetPrettyName() then
				return v
			end
		end
	else
		Aura:Error("Invalid player. (Aura:GetPlyRank(ply) [sh_ranks])")
	end
end

if CLIENT then
	hook.Add("OnPlayerChat","AuraTags",function(ply,msg)
		local str = {}
			if ply:Alive() then
				table.insert(str,Aura:GetPlyRank(ply):GetTagCol())
				table.insert(str,Aura:GetPlyRank(ply):GetTag() .. " ")
				table.insert(str,Aura:GetPlyRank(ply):GetCol())
				table.insert(str,ply:Nick())
				table.insert(str,": ")
				table.insert(str,Color(255,255,255))
				table.insert(str,msg)
			else
				table.insert(str,Color(255,0,0))
				table.insert(str,"*DEAD* ")
				table.insert(str,Aura:GetPlyRank(ply):GetTagCol())
				table.insert(str,Aura:GetPlyRank(ply):GetTag() .. " ")
				table.insert(str,Aura:GetPlyRank(ply):GetCol())
				table.insert(str,ply:Nick() .. ": ")
				table.insert(str,Color(255,255,255))
				table.insert(str,msg)
			end
			chat.AddText(unpack(str))
		return true
	end)
end

for k, v in pairs(player.GetAll()) do
	if IsValid(v) then
		print( k .. " " .. v:Nick())
		print(IsValid(v))
		Aura:SetupRank(v,"user")
	else
		Aura:Error("Player is not valid. (UL)[UL]")
	end
end