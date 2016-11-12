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
	for pUnit in player:Units() do
		NecroUnitPromotionPopulation(pUnit,player);
		NecroUnitPromotionUpgrade(pUnit,player);
		NecroUnitPromotionDuplicate(pUnit,player);
	end
end

function NecroUnitPromotionPopulation(unit,player)
	local id = GameInfo.UnitPromotions.PROMOTION_NECRO_RAISE_THE_DEAD.ID;
	if unit:IsHasPromotion(id) then
		local numCities = player:GetNumCities();
		if(numCities > 0) then
			NecroRemovePromotion(id,unit);
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
			if pop > 5 then
				tCity:SetPopulation(pop+1,true);
			else
				tCity:SetPopulation(pop+2,true);
			end
		end
	end
end
function NecroUnitPromotionUpgrade(unit,player)
	local id = GameInfo.UnitPromotions.PROMOTION_NECRO_ENHANCE_UNIT.ID;
	if unit:IsHasPromotion(id) then
		print("HasPromotion");
		NecroRemovePromotion(id,unit);
		print("RemovedPromotion");
		local plot = unit:GetPlot();
		plot:SetImprovement(GameInfo.Improvements.IMPROVEMENT_GOODY_HUT.ID);
		print("SetGoody");
		player:ReceiveGoody(plot,GameInfoTypes.GOODY_UPGRADE_UNIT,unit);
		print("UpgradedUnit")
	end
end
function NecroUnitPromotionDuplicate(unit,player)	
	local id = GameInfo.UnitPromotions.PROMOTION_NECRO_SUMMON_REINFORCEMENT.ID;
	if unit:IsHasPromotion(id) then
		NecroRemovePromotion(id,unit);
	end
end
function NecroRemovePromotion(id,unit)
	local level = unit:GetLevel();
	local exp = unit:GetExperience();
	unit:SetHasPromotion(id,false);
	unit:SetLevel(level-1);
	unit:SetExperience(exp-5);
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
				if FeatureType == FeatureTypes.NO_FEATURE then 
					pPlot:SetFeatureType(GameInfo.Features.FEATURE_FALLOUT.ID, -1);
				end
			end
		end
	end
end
Events.SerialEventHexCultureChanged.Add(NecroCorruptionSpread)