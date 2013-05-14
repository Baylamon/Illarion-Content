-- INSERT INTO triggerfields VALUES (498,201,0,'triggerfield.galmair_bridges2_660');
-- INSERT INTO triggerfields VALUES (497,201,0,'triggerfield.galmair_bridges2_660');
-- INSERT INTO triggerfields VALUES (496,207,0,'triggerfield.galmair_bridges2_660');

require("base.common")
require("base.factions");
require("lte.deathaftertime");
require("lte.longterm_cooldown");
module("triggerfield.galmair_bridges2_660", package.seeall)


function Init()
    if InitDone then
        return
    end
    monster={};
    monster[1]={921,922,931,932,941,942}; 
    monster[2]={1,2,3,4,5}; 
    monster[3]={201,202,203,204,205}; 
	InitDone = true;
end

function MoveToField(char)
	if char:getType() ~= Character.player then --Monsters will be ingored
		return
	end
	if char:getQuestProgress(660) ~= 0 then --
		return
	end
	if math.random(0,99)< 10  and char:increaseAttrib("hitpoints",0)>0 then --Chance of 10% and Hitpoints above
		if base.factions.getMembership(char) ~= 3 and (char:getSkill(Character.parry)<=30) then
		return
		end
    		Init(); --Initialising
		local level = math.random(1,3)
		local enemy1 = monster[level][math.random(1,table.getn(monster[level]))]
		local enemy2 = monster[level][math.random(1,table.getn(monster[level]))]
		local enemy3 = monster[level][math.random(1,table.getn(monster[level]))]
		local enemy4 = monster[level][math.random(1,table.getn(monster[level]))]
		local enemy5 = monster[level][math.random(1,table.getn(monster[level]))]
		local enemy6 = monster[level][math.random(1,table.getn(monster[level]))]
		local enemy7 = monster[level][math.random(1,table.getn(monster[level]))]
		local enemy8 = monster[level][math.random(1,table.getn(monster[level]))]
		world:gfx(41,position(499,197,0));
        	world:createMonster(enemy1,position(499,197,0),0);
		world:gfx(41,position(498,197,0));
        	world:createMonster(enemy2,position(498,197,0),0);
		world:gfx(46,position(497,197,0));
        	world:createMonster(enemy3,position(497,197,0),0);
		world:gfx(46,position(496,198,0));
        	world:createMonster(enemy4,position(496,198,0),0);
		world:gfx(53,position(498,205,0));
        	world:createMonster(enemy5,position(498,205,0),0);
		world:gfx(53,position(497,206,0));
        	world:createMonster(enemy6,position(497,206,0),0);
 		world:gfx(53,position(499,204,0));
         	world:createMonster(enemy7,position(499,204,0),0);
		world:gfx(53,position(496,207,0));
        	world:createMonster(enemy8,position(496,207,0),0);
		char:inform("Oh nein, ein Hinterhalt!", "Oh no, an ambush!")
		char:setQuestProgress(660,math.random(40,55))
	end
		char:inform("missed chance", "missed chance")  --for testing, remove it later
end


function MoveFromField(char)
	if char:getType() ~= Character.player then
		local test = world:getPlayersInRangeOf(char.pos, 10);
		for i,player in ipairs(test) do
		if base.factions.getMembership(player) == 3 then
			base.character.DeathAfterTime(char,math.random(10,20),0,1)
			player:inform("Bevor du auch noch reagieren kannst, schie�en Pfeile an dir vorbei und t�ten deine Widersacher. Du blickst in die Richtung von wo die Pfeile kamen und siehst die Wachen auf der Stadtmauer von Galmair dir mit ihren Armbr�ste zuwinken. Gut, dass du dem Don deine Steuern zahlst und er dich besch�tzt!", "Even before you are able to react, arrows shouting around you and take down your enemies. You look into the direction of the orgin of the arrows and see guards on the town wall of Galmair waving to you with their crossbows. Good you have paid your taxes to the Don and he protects you!")
			local monsters = world:getMonstersInRangeOf(player.pos, 30);
			for i,mon in ipairs(monsters) do
				base.character.DeathAfterTime(mon,math.random(10,20),0,33)
			end
			return
		elseif test:getQuestProgress(661) ~= 0 then
			return
			
		else
			player:inform("Du wirfst einen Blick zur Stadtmauer von Galmair und siehst die Wachen dort wie sie dich und dein Schicksal beobachten. Was, wenn du nur dem Don deine Steuern zahlen w�rdest?", "You look to the town wall of Galmair and see guards on the wall watching your faith. What if you would pay your taxes to the Don?")	
			test:setQuestProgress(661,5)
		end
		end	
	else
	return
	end
end

