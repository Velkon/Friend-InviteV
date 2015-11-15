/*---------------------------------------------------------------------------
Friend Invite - Velkon.

** Like that scriptfodder addon, but better and free! **

---------------------------------------------------------------------------*/


-- This part sucks
-- Sorry but I can't code derma

net.Receive("finv.menu",function()
surface.CreateFont("FinvShit",{
	font = "DermaLarge",
	size = 20,
	weight = 1000,
	antialias = true
	})
surface.CreateFont("FinvShitPly",{
	font = "DermaLarge",
	size = 27
	})

local blur = Material('pp/blurscreen') -- Mikey
local function draw_Blur(panel, amount) 
	local x, y = panel:LocalToScreen( 0, 0 )
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	for i = 1, 6 do
		blur:SetFloat('$blur', (i / 6) * (amount ~= nil and amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local back = vgui.Create("DFrame")
back:SetSize(300,300)
back:MakePopup()
back:Center()
back:SetTitle("Friend-Invite!")
function back:Paint(w,h)
	draw_Blur( self, 5 )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) )
	draw.RoundedBox( 0, 0, 0, w, 25, Color( 0, 0, 0, 220 ) ) 
	draw.DrawText("Who invited you to the server?","FinvShit",w/2,40,Color(255,255,255),TEXT_ALIGN_CENTER) 
end

local panel = vgui.Create("DPanel",back)
panel:DockMargin(20,40,20,20)
panel:Dock(FILL)
function panel:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(0,0,0,100))
	draw_Blur(self,5)
end

local scroll = vgui.Create("DScrollPanel",panel)
scroll:Dock(FILL)

for k,ply in pairs(player.GetAll()) do --
	if ply == LocalPlayer() then continue end
	local b = vgui.Create("DPanel",scroll)
	b:SetSize(0,40)
	b:DockMargin(0,0,0,2)
	b:Dock(TOP)
	b:SetText("")
	function b:Paint(w,h)
		surface.SetFont("FinvShitPly")
		local tw,th = surface.GetTextSize(ply:Nick()) -- Bad
		draw.RoundedBox(0,0,0,w,h,Color(255,255,255))
		draw.DrawText(ply:Nick(),"FinvShitPly",w/2,h/2 - th/2,Color(100,100,100),TEXT_ALIGN_CENTER)
	end

	local av = vgui.Create("AvatarImage",b)
	av:SetPlayer(ply,64)
	av:SetSize(30,30)
	av:SetPos(5,5)

	local a = vgui.Create("DButton",b)
	a:Dock(FILL)
	a:SetText("")
	function a:Paint() end
	a.DoClick = function()
		back:Remove()
		net.Start("finv.ref")
		net.WriteEntity(ply)
		net.SendToServer()
	end

end
end)
