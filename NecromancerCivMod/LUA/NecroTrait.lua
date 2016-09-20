-- Necro_Trait
-- Author: Jesse
-- DateCreated: 9/14/2016 9:51:08 AM
--------------------------------------------------------------

-- No population growth
-- No Food Generated
print("INIT NECRO LUA SCRIPT")
function NecroGrowthChange(iPlayer)
	print("RUN NECRO LUA SCRIPT")
	local pPlayer = Players[iPlayer]
	if pPlayer:IsAlive() then
		print("PLAYER IS ALIVE")
		if not pPlayer:IsMinorCiv() and not pPlayer:IsBarbarian() then
			print("PLAYER IS A CIV")
			if pPlayer:GetCivilizationType()==GameInfoTypes["CIVILIZATION_NECRO"] then
				print("PLAYER IS A NECROMANCER")
				for pCity in pPlayer:Cities() do
				pCity:SetFood(0)
				end
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(NecroGrowthChange)