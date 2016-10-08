-- Necro_Trait
-- Author: Jesse
-- DateCreated: 9/14/2016 9:51:08 AM
--------------------------------------------------------------

--------------------------------------------------------------
--Central per turn call for necro abilities
--------------------------------------------------------------
function NecroPerTurn(iPlayer)

	print("NecroPerTurn");
	local pPlayer = Players[iPlayer];
	if pPlayer:IsAlive() then
		print("IsAlive");
		if not pPlayer:IsMinorCiv() and not pPlayer:IsBarbarian() then
			print("Is Major Civ");
			if pPlayer:GetCivilizationType()==GameInfoTypes["CIVILIZATION_NECRO"] then
				print("Is Necro");
				NecroPopulationGrowthLimiter(pPlayer);
				NecroUnitPromotionCheck(pPlayer);
			end
		end
	end
end
GameEvents.PlayerDoTurn.Add(NecroPerTurn)


--------------------------------------------------------------
--Removes food from necro controlled cities
--------------------------------------------------------------
function NecroPopulationGrowthLimiter(player)

	print("NecroPopulationGrowthLimiter")
	for pCity in player:Cities() do
	print("City Food Reset.")
	pCity:SetFood(0);
	end
end

--------------------------------------------------------------
--Handles unique unit promotions for necro
--------------------------------------------------------------
function NecroUnitPromotionCheck(player)
	print("NecroUnitPromotionCheck");
	local numCities = player:GetNumCities();
	local id = GameInfo.UnitPromotions.PROMOTION_NECRO_RAISE_THE_DEAD.ID
	if numCities > 0 then
		print("Cities Valid");
		for pUnit in player:Units() do
			print("Check Unit");
			if pUnit:IsHasPromotion(id) then
				print("Unit has id");
				print(numCities);
				-- Reset promotion state,
				--	-Lower level/experience
				--	-Decrease experience, if needed.
				local level = pUnit:GetLevel();
				print(level);
				local experience = pUnit:GetExperience();
				print(experience);
				pUnit:SetLevel(level-1);
				pUnit:SetExperience(experience-10);
				pUnit:SetHasPromotion(id,false);
				
				-- Find random city, add one to population.
				local iCity = 1;
				if not numCities == 1 then
					iCity = math.random(numCities);
				end
				local tCity;
				for pCity in player:Cities() do
					iCity = (iCity - 1);
					if iCity == 0 then
						tCity = pCity;
					end
				end
				local pop = tCity:GetPopulation();
				print(pop);
				tCity:SetPopulation(pop+1,true);
			end
		end
	end
end