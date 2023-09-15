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
