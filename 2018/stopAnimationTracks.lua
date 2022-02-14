Animate.Disabled = true
spawn(function()
	for i, tracks in pairs(Humanoid:GetPlayingAnimationTracks()) do
		tracks:Stop()
	end
end)