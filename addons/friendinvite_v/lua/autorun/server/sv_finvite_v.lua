/*---------------------------------------------------------------------------
Friend Invite - Velkon.

** Like that scriptfodder addon, but better and free **

---------------------------------------------------------------------------*/
finv = {}
util.AddNetworkString("finv.ref")
util.AddNetworkString("finv.menu")
file.CreateDir("finv") -- Another great optimized bit
/*---------------------------------------------------------------------------
Config - This is where you edit shit
---------------------------------------------------------------------------*/

finv.steamapi = "YOUR STEAM API KEY THING" -- Your steam API key, if you want to check family shared games or playtime on gmod
-- You can get a steam api key at http://steamcommunity.com/dev/apikey

finv.cmd = "refer" -- The chat command for the the friend invite menu, with no ! or /

finv.familyshare = true -- If true, dissallow family shared people to be reffered/refer

finv.playtime = 18000 -- The minimum amount of minutes the account must have to be reffered/refer. 
-- (18000 is 300 hours)
-- Set to 0 to disable.

finv.reward = function(ply,ref)
	-- The reward for referring 
	ply:ChatPrint("Thanks for referring "..ref:Nick().."! You have been given $50,000!")
	ply:addMoney(50000)
	ref:ChatPrint(ply:Nick().." referred you! ")
end

/*---------------------------------------------------------------------------
End of config
---------------------------------------------------------------------------*/

function finv.CheckTime(ply)
	if not IsValid(ply) then return end
	http.Fetch("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key="..finv.steamapi.."&steamid="..ply:SteamID64().."&format=json",function(body)
		local games = util.JSONToTable(body)
		for k,v in pairs(games["response"]["games"]) do
			if v["appid"] == 4000 then
				if v["playtime_forever"] > finv.playtime then
					ply.finvpt = 1
				else
					ply.finvpt = 0
				end
			end
		end
	end)
end
// This sucks.
// cba to string match
function finv.CheckShared(ply)
	if not IsValid(ply) then return end
	http.Fetch("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key="..finv.steamapi.."&steamid="..ply:SteamID64().."&appid_playing=4000&format=json",function(body)
		local a = util.JSONToTable(body)
		ply.finvshared = a["response"]["lender_steamid"]
	end)
end
// This too

local cmd = "[!/]"..finv.cmd:lower():gsub("[!/]","").."$"
hook.Add("PlayerSay","FinvMenu",function(ply,txt)
	if txt:match(cmd) then
		net.Start("finv.menu")
		net.Send(ply)
		return ""
	end
end)

function finv.save(sid,refs)
	file.Write("finv/"..sid..".txt",refs)
end

net.Receive("finv.ref",function(l,ply)
	local ref = net.ReadEntity()
	if not IsValid(ref) then return end
	if ref == ply or not ref:IsPlayer() then return end -- No cheeky shit!
	if file.Exists("finv/"..ply:SteamID64()..".txt","DATA") then
		ply:ChatPrint("You can't refer more people!")
		return
	end
	local a = file.Read("finv/"..ply:SteamID64()..".txt","DATA")
	if a then
		if a == ref:SteamID64() then 
			ply:ChatPrint(ref:Nick().. " referred you! You cant refer him back!")
			return 
		end
	end
	if finv.familyshare then
		finv.CheckShared(ply)
		finv.CheckShared(ref)
	end
	if finv.playtime != 0 then
		finv.CheckTime(ply)
		finv.CheckTime(ref)
	end
	timer.Create("Ref:::"..ply:Nick(),1,0,function() -- no better way of doing this.

		-- Don't look at this bit, I was really tired.
		-- Infact, I was tired for this whole thing really
		-- Fix it if you wish.

		if finv.familyshare and finv.playtime ~= 0 then -- both
			if ( ply.finvshared and ply.finvpt ) and ( ref.finvshared and ref.finvpt ) then
				if ( ply.finvshared == "0" ) and ( ref.finvshared == "0" ) then
					if ( ply.finvpt == 1 ) and ( ref.finvpt == 1 ) then
						finv.reward(ply,ref)
						finv.save(ref:SteamID64(),ply:SteamID64())
						finv.save(ply:SteamID64(),ref:SteamID64())
						timer.Remove("Ref:::"..ply:Nick())
						return
					end
				end
			end
		end

		if not finv.familyshare and finv.playtime == 0 then -- none
			finv.reward(ply,ref)
			timer.Remove("Ref:::"..ply:Nick())
		end

		if not finv.familyshare and finv.playtime ~= 0 then -- pt only
			if ( ply.finvpt ) and ( ref.finvpt ) then
				if ( ply.finvpt == 1 ) and ( ref.finvpt == 1 ) then
					finv.reward(ply,ref)
					finv.save(ref:SteamID64(),ply:SteamID64())
					inv.save(ply:SteamID64(),ref:SteamID64())
					timer.Remove("Ref:::"..ply:Nick())
					return
				end
			end
		end

		if finv.familyshare and finv.playtime ~= 0 then -- shared only
			if ( ply.finvshared  ) and ( ref.finvshared ) then
				if ( ply.finvshared == "0" ) and ( ref.finvshared == "0" ) then
					finv.reward(ply,ref)
					finv.save(ref:SteamID64(),ply:SteamID64())
					inv.save(ply:SteamID64(),ref:SteamID64())
					timer.Remove("Ref:::"..ply:Nick())
					return
				end
			end
		end


	end)
end)

print("Loaded Friend-Invite-V")