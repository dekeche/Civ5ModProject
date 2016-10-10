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
GameEvents.PlayerDoTurn.Add(NecroPerTurn)

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
	local id = GameInfo.UnitPromotions.PROMOTION_NECRO_RAISE_THE_DEAD.ID
	if numCities > 0 then
		for pUnit in player:Units() do
			if pUnit:IsHasPromotion(id) then
				-- Reset promotion state,
				--	-Lower level/experience
				--	-Decrease experience, if needed.
				local level = pUnit:GetLevel();
				local experience = pUnit:GetExperience();
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

--------------------------------------------------------------
--Detect necro city expansion/creation, I assume.
--Check tile, Check for features/Improvements
--Change Features/Improvements as needed.
--------------------------------------------------------------
function NecroCorruptionSpread(hexX, hexY, player, unknown)	
	local pPlayer = Players[player];
	if pPlayer:IsAlive() then
		print("IsAlive");
		if not pPlayer:IsMinorCiv() and not pPlayer:IsBarbarian() then
			print("Is Major Civ");
			if pPlayer:GetCivilizationType()==GameInfoTypes["CIVILIZATION_NECRO"] then
				print("Is Necro");
				local gridPosX, gridPosY = ToGridFromHex( hexX, hexY );
				local pPlot = Map.GetPlot(gridPosX,gridPosY);
				FeatureType = pPlot:GetFeatureType();
				print(GameInfo.Features.FEATURE_FOREST_CORRUPT.ID);
				if FeatureType == FeatureTypes.NO_FEATURE then 
					pPlot:SetFeatureType(GameInfo.Features.FEATURE_CORRUPTION.ID, -1);
				elseif FeatureType == FeatureTypes.FEATURE_JUNGLE then
					pPlot:SetFeatureType(GameInfo.Features.FEATURE_JUNGLE_CORRUPT.ID, -1);
				elseif FeatureType == FeatureTypes.FEATURE_MARSH then
					pPlot:SetFeatureType(GameInfo.Features.FEATURE_MARSH_CORRUPT.ID, -1);
				elseif FeatureType == FeatureTypes.FEATURE_OASIS then
					pPlot:SetFeatureType(GameInfo.Features.FEATURE_OASIS_CORRUPT.ID, -1);
				elseif FeatureType == FeatureTypes.FEATURE_FLOOD_PLAINS then
					pPlot:SetFeatureType(GameInfo.Features.FEATURE_FLOOD_PLAINS_CORRUPT.ID, -1);
				elseif FeatureType == FeatureTypes.FEATURE_FOREST then
					pPlot:SetFeatureType(GameInfo.Features.FEATURE_FOREST_CORRUPT.ID, -1);
				elseif FeatureType == FeatureTypes.FEATURE_FALLOUT then
				elseif FeatureType == FeatureTypes.FEATURE_ICE then
				else
				end
			end
		end
	end
end
Events.SerialEventHexCultureChanged.Add(NecroCorruptionSpread)