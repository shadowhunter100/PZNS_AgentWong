local PZNS_DebuggerUtils = require("02_mod_utils/PZNS_DebuggerUtils");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");
require "11_events_spawning/PZNS_Events"; -- Cows: THIS IS REQUIRED, DON'T MESS WITH IT, ALWAYS KEEP THIS AT TOP
--------------------------------------- End Framework Requirements ---------------------------------------------
require("pzns_agentwong/PZNS_AgentWong");
local PZNS_AgentWongSpeechTable = require("pzns_agentwong/PZNS_AgentWongSpeechTable");

local isFrameWorkIsInstalled = false;
local isAgentWongSpawned = false;

-- Cows: with the recent sandbox options update, users can use the sandbox option to clear ALL NPCs needs hourly. Only use this function if you want to override the sandbox option.
local function clearNPCsNeeds()
    local PZNS_AgentWong = "PZNS_AgentWong";
    local agentWong = PZNS_NPCsManager.getActiveNPCBySurvivorID(PZNS_AgentWong);
    PZNS_UtilsNPCs.PZNS_ClearNPCAllNeedsLevel(agentWong); 
end

--- Cows: Automatically Re-set the custom npc speech table, this is to ensure the custom npc always uses the latest speech table if an update occurs.
local function ResetNPCSpeechTable()
    local npcSurvivorID = "PZNS_AgentWong";
    local npcSurvivor = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    if (npcSurvivor ~= nil) then
        PZNS_UtilsNPCs.PZNS_SetNPCSpeechTable(npcSurvivor, PZNS_AgentWongSpeechTable);
    end
end

--- Cows: Check if the Framework installed and create a group if true (and if needed)
---@return boolean
local function checkIsFrameWorkIsInstalled()
    local activatedMods = getActivatedMods();
    local frameworkID = "PZNS_Framework";
    --
    if (activatedMods:contains(frameworkID)) then
        isFrameWorkIsInstalled = true;
        ResetNPCSpeechTable();
    else
        -- Cows: Else alert user about not having PZNS_Framework installed...
        local function callback()
            getSpecificPlayer(0):Say("!!! PZNS_AgentWong IS NOT ACTIVE !!!");
            getSpecificPlayer(0):Say("!!! PZNS_Framework IS NOT INSTALLED !!!");
        end
        Events.EveryOneMinute.Add(callback);
    end

    return isFrameWorkIsInstalled;
end

--- Cows: This is an in-game every one minute check (about 2 seconds in real-life time by default)
--- This is needed because not all NPCs will spawn within range of the player's loaded cell and must therefore be checked regularly to spawn in-game.
local function npcsSpawnCheck()
    if (isFrameWorkIsInstalled == true) then
        local function wongCallback()
            isAgentWongSpawned = PZNS_SpawnAgentWong();
        end
        local function checkIsNPCSpawned()
            if (isAgentWongSpawned == true) then
                Events.EveryOneMinute.Remove(wongCallback);
                Events.EveryOneMinute.Remove(checkIsNPCSpawned);
            end
        end
        Events.EveryOneMinute.Add(wongCallback);
        Events.EveryOneMinute.Add(checkIsNPCSpawned);
        -- Events.EveryHours.Add(clearNPCsNeeds); -- Cows: Optional, commented out
    end
end

Events.OnGameStart.Add(checkIsFrameWorkIsInstalled);
Events.OnGameStart.Add(npcsSpawnCheck);
