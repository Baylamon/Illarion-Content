--[[
Illarion Server

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

-- This is ugly but functional code to handle the skill transfer to new skills. This code should be deleted after the 1th January 2017
-- Clean up the various tool scripts as well then

local common = require("base.common")
local M = {}

local function transferSkillCookingHerbloreFarming(user)
    local cookingBakingTable = user:getSkillValue(Character.cookingAndBaking)
    local herbloreTable = user:getSkillValue(Character.herblore)
    local farmingTable = user:getSkillValue(Character.farming)
    
    cookingBakingTable = cookingBakingTable or {major = 0, minor = 0}
    herbloreTable = herbloreTable or {major = 0, minor = 0}
    farmingTable = farmingTable or {major = 0, minor = 0}
    
    if (cookingBakingTable.major < 1 and herbloreTable.major < 1 and farmingTable.major < 1) or user:getQuestProgress(40) ~= 0 then
        return false
    end
    
    local changes = {}
    changes[0] = {textDe = "�ndere nichts.", textEn = "Change nothing.", 
    exec = function(user, skillValues) user:inform(common.GetNLS(user,"Du hast dich daf�r entschieden, keine Ver�nderungen vorzunehmen.", "You decided to change nothing."), Character.highPriority); end}
    
    changes[1] = {textDe = "�bertrage deine Punkte von Kochen und Backen auf Landwirtschaft.", textEn = "Transfer your points from Cooking and Baking to Husbandry.", 
    exec = function(user, skillValues) user:inform(common.GetNLS(user,"Du hast dich daf�r entschieden, deine Punkte von Kochen und Backen auf Landwirtschaft zu �bertragen.", "You decided to transfer your points from Cooking and Baking to Husbandry"), Character.highPriority); user:setSkill(Character.husbandry, skillValues.cookingBakingTable.major, cookingBakingTable.minor); user:setSkill(Character.cookingAndBaking, 0, 0); end}
    
    changes[2] = {textDe = "�bertrage deine Punkte von Kochen und Backen auf Brauerei.", textEn = "Transfer your points from Cooking and Baking to Brewing.", 
    exec = function(user, skillValues) user:inform(common.GetNLS(user,"Du hast dich daf�r entschieden, deine Punkte von Kochen und Backen auf Brauerei zu �bertragen.", "You decided to transfer your points from Cooking and Baking to Brewing"), Character.highPriority); user:setSkill(Character.brewing, skillValues.cookingBakingTable.major, skillValues.cookingBakingTable.minor); user:setSkill(Character.cookingAndBaking, 0, 0); end}
    
    changes[3] = {textDe = "�bertrage deine Punkte von Kr�uterkunde auf Landwirtschaft.", textEn = "Transfer your points from Herblore to Husbandry.", 
    exec = function(user, skillValues) user:inform(common.GetNLS(user,"Du hast dich daf�r entschieden, deine Punkte von Kr�uterkunde auf Landwirtschaft zu �bertragen.", "You decided to transfer your points from Herblore to Husbandry"), Character.highPriority); user:setSkill(Character.husbandry, skillValues.herbloreTable.major, skillValues.herbloreTable.minor); user:setSkill(Character.herblore, 0, 0); end}
    
    changes[4] = {textDe = "�bertrage deine Punkte von Kochen und Backen auf Brauerei.\nUnd �bertrage deine punkte von Kr�uterkunde auf Landwirtschaft.", 
    textEn = "Transfer your points from Cooking and Baking to Brewing.\nAnd transfer your points from Herblore to Husbandry.", 
    exec = function(user, skillValues) user:inform(common.GetNLS(user,"Du hast dich daf�r entschieden, deine Punkte von Kr�uterkunde auf Landwirtschaft zu �bertragen und deine Punkte von Kochen und Backen auf Brauerei zu verschieben.", "You decided to transfer your points from Herblore to Husbandry and to transfer your points from Cooking and Baking to Brewing.")); user:setSkill(Character.husbandry, skillValues.herbloreTable.major, skillValues.herbloreTable.minor); user:setSkill(Character.herblore, 0, 0); user:setSkill(Character.brewing, skillValues.cookingBakingTable.major, skillValues.cookingBakingTable.minor); user:setSkill(Character.cookingAndBaking, 0, 0); end}
    
    changes[5] = {textDe = "�bertrage deine Punkte von Ackerbau auf Landwirtschaft.", textEn = "Transfer your points from Farming to Husbandry.", 
    exec = function(user, skillValues) user:inform(common.GetNLS(user,"Du hast dich daf�r entschieden, deine Punkte von Ackerbau auf Landwirtschaft zu �bertragen.", "You decided to transfer your points from Farming to Husbandry", Character.highPriority)); user:setSkill(Character.husbandry, skillValues.farmingTable.major, skillValues.farmingTable.minor); user:setSkill(Character.farming, 0, 0); end}
    
    changes[6] = {textDe = "�bertrage deine Punkte von Kochen und Backen auf Brauerei.\nUnd �bertrage deine punkte von Ackerbau auf Landwirtschaft.", textEn = "Transfer your points from Cooking and Baking to Brewing.\nAnd transfer your points from Farming to Husbandry.", 
    exec = function(user, skillValues) user:inform(common.GetNLS(user,"Du hast dich daf�r entschieden, deine Punkte von Ackerbau auf Landwirtschaft zu �bertragen und deine Punkte von Kochen und Backen auf Brauerei zu verschieben.", "You decided to transfer your points from Farming to Husbandry and to transfer your points from Cooking and Baking to Brewing.")); user:setSkill(Character.husbandry, skillValues.farmingTable.major, skillValues.farmingTable.minor); user:setSkill(Character.farming, 0, 0); user:setSkill(Character.brewing, skillValues.cookingBakingTable.major, skillValues.cookingBakingTable.minor); user:setSkill(Character.cookingAndBaking, 0, 0); end}
    

    local changeIds
    if cookingBakingTable.major > 0 and herbloreTable.major < 1 and farmingTable.major < 1 then
        changeIds = {0, 1, 2}
    elseif cookingBakingTable.major < 1 and herbloreTable.major > 0 and farmingTable.major < 1 then
        changeIds = {0, 3}
    elseif cookingBakingTable.major < 1 and herbloreTable.major < 1 and farmingTable.major > 0 then
        changeIds = {0, 5}
    elseif cookingBakingTable.major < 1 and herbloreTable.major > 0 and farmingTable.major > 0 then
        changeIds = {0, 5, 3}
    elseif cookingBakingTable.major > 0 and herbloreTable.major > 0 and farmingTable.major < 1 then
        changeIds = {0, 1, 2, 3, 4}
    elseif cookingBakingTable.major > 0 and herbloreTable.major < 1 and farmingTable.major > 0 then
        changeIds = {0, 1, 2, 5, 6}
    elseif cookingBakingTable.major > 0 and herbloreTable.major > 0 and farmingTable.major > 0 then
        changeIds = {0, 1, 2, 3, 4, 5, 6}
    end
    
    local callback = function(dialog)
        local success = dialog:getSuccess() 
        if not success then
            user:inform("Du wirst dieses Handwerk nicht ausf�hren k�nnen, bis du dich entschieden hast.", "You won't be able to do this craft until you have decided for an option.", Character.highPriority)
        elseif user:getQuestProgress(40) == 0 then
            user:setQuestProgress(40, 1)
            local selected = dialog:getSelectedIndex()+1
            changes[changeIds[selected]].exec(user, {cookingBakingTable = cookingBakingTable, herbloreTable = herbloreTable, farmingTable = farmingTable})
        end
    end
    
    local dialog
    if user:getPlayerLanguage() == Player.german then
        dialog = SelectionDialog("Neue Handwerksf�higkeiten", "Was m�chtest du tun?", callback)
    else
        dialog = SelectionDialog("New crafting skills", "What do you want to do?", callback)
    end
    
    for i=1, #changeIds do
        dialog:addOption(0, common.GetNLS(user, changes[changeIds[i]].textDe, changes[changeIds[i]].textEn))
    end
    user:requestSelectionDialog(dialog)
    
end

function M.skillTransferInformCookingHerbloreFarming(user)
    local cookingBakingTable = user:getSkillValue(Character.cookingAndBaking)
    local herbloreTable = user:getSkillValue(Character.herblore)
    local farmingTable = user:getSkillValue(Character.farming)
    
    if (cookingBakingTable.major < 1 and herbloreTable.major < 1 and farmingTable.major < 1) or user:getQuestProgress(40) ~= 0 then
        return false
    end
    
    local infText = common.GetNLS(user,
       "Illarion hat zwei neue Skills: Brauerei und Landwirtschaft.\nIm folgenden wirst du die M�glichkeit haben, deine Skills anzupassen, wenn du das w�schst.\n\nLandwirtschaft umfasst das Braten am R�ucherofen (zuvor geh�rte das zum Kochen und Backen Skill), das �lpressen (das geh�rte zuvor zu Kr�uterkunde) und das Sammeln von Waben und Verarbeiten von diesen zu Kerzen (beides zuvor Teil von Ackerbau.\n\nBrauerei umfasst das Herstellen von Getr�nken aller Art. Dies wurde aus dem Kochen und Backen Skill entfernt.\n\nKlicke auf 'Okay' um zu den m�glichen Anpassungsoptionen zu gelangen. Bitte bedenke, dass du deine Entscheidung nicht im Nachinein �ndern kannst.",
       
       "Illarion has two new Skills: Brewing and Husbandry.\nYou have now the option to adjust your skills if you wish to do so.\nHusbandry handles now smoking food in the smoke oven (Formerly, this was part of Cooking and Baking.), making oil from thistles (formerly part of Herblore), and collecting honeycombs and making candles from them (formlery part of farming).\nBrewing is producing all kinds of drinks (This was formerly part of Cooking and Baking).\nClick 'Okay' to get to the possible option for adjusting your skills. Mind that you cannot undo your decission afterwards.")
    local title = common.GetNLS(user,"Neue Handwerksskills","New crafting skills")

    local closeTrib=function(onClose)
        transferSkillCookingHerbloreFarming(user)
    end

    local dialogue=MessageDialog(title,infText,closeTrib)
    user:requestMessageDialog(dialogue)
    return true
end

return M