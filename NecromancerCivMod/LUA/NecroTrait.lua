-- Necro_Trait
-- Author: Jesse
-- DateCreated: 9/14/2016 9:51:08 AM
--------------------------------------------------------------

--------------------------------------------------------------
--Central per turn call for necro abilities
--------------------------------------------------------------
function NecroPerTurn(iPlayer)
	local pPlayer = Players[iPlayer];
	if pPlayer:IsAlive() then
		if not pPlayer:IsMinorCiv() and not pPlayer:IsBarbarian() then
			if pPlayer:GetCivilizationType()==GameInfoTypes["CIVILIZATION_NECRO"] then
				NecroPopulationGrowthLimiter(pPlayer);
				NecroUnitPromotionCheck(pPlayer);
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(NecroGrowthChange)


--------------------------------------------------------------
--Removes food from necro controlled cities
--------------------------------------------------------------
function NecroPopulationGrowthLimiter(player)
	for pCity in player:Cities() do
	pCity:SetFood(0);
	end
end

--------------------------------------------------------------
--Handles unique unit promotions for necro
--------------------------------------------------------------
function NecroUnitPromotionCheck(player)
	local numCities = player:GetNumCities();
	if numCities > 0 then
		for pUnit in player:Units() do
			if pUnit:IsHasPromotion(GameInfo["UnitPromotions"].["PROMOTION_NECRO_RAISE_THE_DEAD"]) then
				
				-- Reset promotion state,
				--	-Lower level/experience
				--	-Decrease experience, if needed.
				local level = pUnit:GetLevel();
				--local experience = pUnit:GetExperience();
				pUnit:SetLevel(level-1);
				--pUnit:SetExperience(experience-10);
				pUnit:SetHasPromotion(GameInfo["UnitPromotions"].["PROMOTION_NECRO_RAISE_THE_DEAD"],false);
				
				-- Find random city, add one to population.
				local iCity = math.random(numCites);
				local tCity = player:Cities()[iCity];
				local pop = tCity:GetPopulation();
				tCity:SetPopulation(pop+1,true);
			end
		end
	end
end