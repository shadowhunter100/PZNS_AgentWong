local PZNS_DebuggerUtils = require("02_mod_utils/PZNS_DebuggerUtils");
local PZNS_PlayerUtils = require("02_mod_utils/PZNS_PlayerUtils");
local PZNS_UtilsDataGroups = require("02_mod_utils/PZNS_UtilsDataGroups");
local PZNS_UtilsDataNPCs = require("02_mod_utils/PZNS_UtilsDataNPCs");
local PZNS_UtilsDataZones = require("02_mod_utils/PZNS_UtilsDataZones");
local PZNS_UtilsNPCs = require("02_mod_utils/PZNS_UtilsNPCs");
local PZNS_WorldUtils = require("02_mod_utils/PZNS_WorldUtils");
local PZNS_NPCGroupsManager = require("04_data_management/PZNS_NPCGroupsManager");
local PZNS_NPCsManager = require("04_data_management/PZNS_NPCsManager");

--- Cows: Example of spawning in an NPC. This NPC is "Agent Wong"
function PZNS_SpawnAgentWong()
    local npcSurvivorID = "PZNS_AgentWong";
    local isNPCActive = PZNS_NPCsManager.getActiveNPCBySurvivorID(npcSurvivorID);
    local isSpawned = false;
    -- Cows: Check if the NPC is active before continuing.
    if (isNPCActive == nil) then
        local playerSurvivor = getSpecificPlayer(0);
        -- Cows: This should spawn Wong in the Rosewood Fire Department, 2nd floor.
        local spawnX, spawnY, spawnZ = 8140, 11740, 1;
        local isInSpawnRange = PZNS_WorldUtils.PZNS_IsSquareInPlayerSpawnRange(playerSurvivor, spawnX, spawnY, spawnZ);
        -- Cows: Check if npc isInSpawnRange
        if (isInSpawnRange == true) then
            --
            local spawnSquare = getCell():getGridSquare(
                spawnX, -- GridSquareX
                spawnY, -- GridSquareY
                spawnZ  -- Floor level
            );
            local npcSurvivor = PZNS_NPCsManager.createNPCSurvivor(
                npcSurvivorID, -- Unique Identifier for the npcSurvivor so that it can be managed.
                true,          -- isFemale
                "Wong",        -- Surname
                "Agent",       -- Forename
                spawnSquare    -- Square to spawn at
            );
            --
            if (npcSurvivor ~= nil) then
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Strength", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Fitness", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Aiming", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorPerkLevel(npcSurvivor, "Reloading", 5);
                PZNS_UtilsNPCs.PZNS_AddNPCSurvivorTraits(npcSurvivor, "Lucky");
                -- Cows: Setup npcSurvivor outfit... Example mod patcher check
                -- "ada_wong" is a costume mod created/uploaded by "Satispie" at https://steamcommunity.com/sharedfiles/filedetails/?id=2908872385
                if (PZNS_DebuggerUtils.PZNS_IsModActive("ada_wong") == true) then
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.ada_wong");
                else
                    -- Cows: Else use vanilla assets
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Vest_DefaultTEXTURE");
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Skirt_Mini");
                    PZNS_UtilsNPCs.PZNS_AddEquipClothingNPCSurvivor(npcSurvivor, "Base.Shoes_ArmyBoots");
                    PZNS_UtilsNPCs.PZNS_AddItemToInventoryNPCSurvivor(npcSurvivor, "Base.BaseballBat");
                end
                PZNS_UtilsNPCs.PZNS_AddEquipWeaponNPCSurvivor(npcSurvivor, "Base.Pistol");
                -- Cows: Set the job...
                PZNS_UtilsNPCs.PZNS_SetNPCJob(npcSurvivor, "Guard");
                -- Cows: Begin styling customizations...
                PZNS_UtilsNPCs.PZNS_SetNPCHairModel(npcSurvivor, "F_Agent");
                PZNS_UtilsNPCs.PZNS_SetNPCHairColor(npcSurvivor, 0.105882354, 0.09019608, 0.08627451);
                PZNS_UtilsNPCs.PZNS_SetNPCSkinTextureIndex(npcSurvivor, 1);
                PZNS_UtilsNPCs.PZNS_SetNPCSkinColor(npcSurvivor, 1.0, 1.0, 1.0, 1.0);
                PZNS_UtilsDataNPCs.PZNS_SaveNPCData(npcSurvivorID, npcSurvivor);
                isSpawned = true;
            end
        end
    else
        -- Cows: Else NPC already spawned or already exists.
        isSpawned = true;
    end
    return isSpawned;
end
