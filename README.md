# Civ5ModProject
Project for using and experimenting with lua, Basically decided that making mods for Civ 5 would be the best platform for this.

##Necromancer Civ
Basic concept; add a necromancer civilization to civ 5.
The basic features of this civ are: no food/population decrease, more production/faith/culture/science buildings and improvements (replace food related ones). Possible automatic negitive terrain improvements (remove food from tiles). Units are cheaper than other civs, but also weaker. Population gain through battle.


###Unique promotions
All necromancer millitary units will be unable to gain normal promotions, but instead will have 3 unique promotions to choose from.
Raise the Dead: Adds one population to a random city belonging to the player.
Replicate: Produces a unit of the same type at the location of this unit.
Upgrade: Upgrades the unit for free.

###Unique buildings
All food and population buildings will be replaced, new buildings will have a unique focus. Specific values subject to change, so only focus will be given.
Watermill -> Bonemill (Production)
Aqueduct -> Blood River (Culture and Faith)
Lighthouse -> Ghost Light (Science)
Granary -> Blood Storage (Culture, Faith from resources)
Hospital -> Corrupt Graveyard (Culture and Faith)
Medical Lab -> Necromancer Tower (Culture and Faith)
Hanging Gardens(wonder) -> Corrupt Hanging Garden (Culture) To be tested. The Hanging Gardens need to be modified to prevent unintended food production, however I do not know if modifying a world wonder like this will work. This need to be tested to see if other civ's can still build the gardens if the unique varient is built, and also if the unique varient can still be built if the original is built elswere.

###Unique improvements
Corruption - potential improvemnt placed on any land in the territory of a necromancer, can be cleared off easily. -3 food, so the land will be incapable of producing any food.
Corrupt forest - same as above, replaces forest on land.
 Other civs should be able to clear these off with a worker, unique improvements for Necromancer will not require it.
Corrupt Graveyard - Unique improvement that increases production and faith.
Corrupt Mine - Unique improvement that increases production.
Corrupt Trade - Unique improvement for gold. (may not be needed)
?Corrupt Lumbermil? - possible alternative version of the lumbermill. (may not needed)

All unique great person improvemnts should be replaced as well, to enable placement on top of corrupt lands, or to provide the same -3 food.

###Unique Units:
This is only a possibility, but I would like to implement new upgrade paths for units, using the upgrade promotion. Creating a bone dragon seems like a good idea. But this is not necessary, and is more of a streach goal.

##Playstyle
The necromancer is an aggressive civ, it utilizes large number of weaker units to overwelm the opposition. In order to expand, the necromancer must fight. Cheap units that can easily be upgraded are the necromancer's bread and butter. On the home front, many buildings allow for faith and culture improvement, so borders will quickly expand and the civ benefits from many early social perks. The faith also allows for the quick establishment of religion, and further bonusses from that. (may need to look into disabling some religion traits, or mitegating the effects.)

##Coding plan
Basic buildings, units, promotion, and some of the effects from the trait can be done in XML. It may be possible to create a new free building for the Necromancers, to allow for +2 food per population. This is necissary because in experimentation, using lua script to add x food seems to still cause starvation, though oddly enough adding a set amount of food, like 10, will prevent starvation.

The basic goal of the LUA scripting will be to keep city population stable, handle unit promotion, and handle city expansion (corrupt terrain).

###City population
This is almost done and tested, but basically a once per turn check, GameEvents.PlayerDoTurn.
The basis to to look for the necromancer, look at each city, and set the food to 0, or 2*population. I tested successfully with food to 10, however 2*population did not appear to work. this may be because the city was not giving the correct # population, or could be some other factor. Easiest way to solve would be with XML free building for 2*population food, and set food at city to 0.

###Unit promotion
Looking over the game events for LUA, there is no event trigger when unit is promoted. There is also no XML argument for lua script to run when unit promoted, or promotion chosen. As such, the only way to implement this seems to be through GameEvents.PlayerDoTurn. This will be implemented as a check for the Necromancer, Check on each necromancer unit, and check for each promotion. If unit has promotion, remove promotion and activate the ability. (Need to test if using XML argument for healing auto-removes the promotion. I do wish for the promotions to heal the unit, but this needs testing)

###City expansion
The base idea is to remove all food production around the city, putting the player in the right mindset that food is not used, as food cannot simply be dissabled from collection, the simplest method will be to add improvements to all workable tiles that provide negative food. Research has shown that civ 5 does not allow negative production values on tiles, but this needs testing. (2-3 = 0, not -1). Events.SerialEventHexCultureChanged Seems to be the proper event for this, as it will trigger whenever the city culture expands. When triggered, check to see if the expansion is from the necromancer, and if so replace the tile improvemnts with all applicable. (corrupt on base, farms->graveyards) This needs testing, to see if it works for city founding, city expansion, and conquest of a city.
