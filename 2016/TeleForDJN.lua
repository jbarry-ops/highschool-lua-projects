player = game.Players.LocalPlayer
mouse = player:GetMouse()
mouse.Button1Down:connect(function()
	player.Character:MoveTo(mouse.Hit.p)
end)