test = function()
	function shot0(weapon, enemy)
		if weapon:GetAttribute("Ammo") ~= nil then
			if Player:DistanceFromCharacter(enemy.Position) < weapon:GetAttribute("Range")*_G.Range then
				weapon.Main:FireServer("MUZZLE", weapon.Handle.Barrel)
				for i = 1, 4 do
					weapon.Main:FireServer("DAMAGE", {[1]=enemy,[2] = enemy.Position,[3]=100})
				end
				weapon.Main:FireServer("AMMO")
			end
		end
	end
	_G.autofarm = state
	while _G.autofarm do
		wait()
		pcall(function()
			local enemy
			local distance = 9216

			local enemies = merge_tables(
				NPCs.Monsters:GetChildren(), 
				NPCs.Tango:GetChildren()
			)

			for i,v in enemies do
				if Player:DistanceFromCharacter(v.Head.Position) < distance then
					enemy = v
					distance = Player:DistanceFromCharacter(v.Head.Position)
				end
			end

			local v = enemy.Head
			repeat task.wait()
				auto_equip()
				for _, tool in Player.Character:GetChildren() do
					shot0(tool, v)
				end
			until v.Parent.Humanoid.Health == 0 or _G.autofarm == false
		end)
	end
end
