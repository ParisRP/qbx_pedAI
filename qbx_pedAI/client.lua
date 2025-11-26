--[[
    Advanced AI Ped System v2.0 - TOUS LES PEDS
    Système d'IA ultra-réaliste pour FiveM
    Optimisé 0ms - Performance maximale
    Compatible Qbox Framework
]]

local QBXCore = exports['qbx_core'] exports.qbx_core:GetPlayerData()
local spawnedPeds = {}
local activeAI = {}
local config = {
    maxPeds = 100,
    updateInterval = 800,
    interactionDistance = 30.0,
    visionRange = 40.0,
    hearingRange = 25.0,
    memoryDuration = 300000,
    spawnRadius = 150.0,
    despawnRadius = 200.0
}

-- LISTE COMPLÈTE DE TOUS LES MODÈLES DE PEDS GTA V
local pedModels = {
    -- Civils Hommes
    `a_m_m_afriamer_01`, `a_m_m_beach_01`, `a_m_m_beach_02`, `a_m_m_bevhills_01`, `a_m_m_bevhills_02`,
    `a_m_m_business_01`, `a_m_m_eastsa_01`, `a_m_m_eastsa_02`, `a_m_m_farmer_01`, `a_m_m_fatlatin_01`,
    `a_m_m_genfat_01`, `a_m_m_genfat_02`, `a_m_m_golfer_01`, `a_m_m_hasjew_01`, `a_m_m_hillbilly_01`,
    `a_m_m_hillbilly_02`, `a_m_m_indian_01`, `a_m_m_ktown_01`, `a_m_m_malibu_01`, `a_m_m_mexcntry_01`,
    `a_m_m_mexlabor_01`, `a_m_m_og_boss_01`, `a_m_m_paparazzi_01`, `a_m_m_polynesian_01`, `a_m_m_prolhost_01`,
    `a_m_m_rurmeth_01`, `a_m_m_salton_01`, `a_m_m_salton_02`, `a_m_m_salton_03`, `a_m_m_salton_04`,
    `a_m_m_skater_01`, `a_m_m_skidrow_01`, `a_m_m_socenlat_01`, `a_m_m_soucent_01`, `a_m_m_soucent_02`,
    `a_m_m_soucent_03`, `a_m_m_soucent_04`, `a_m_m_stlat_02`, `a_m_m_tennis_01`, `a_m_m_tourist_01`,
    `a_m_m_trampbeac_01`, `a_m_m_tramp_01`, `a_m_m_tranvest_01`, `a_m_m_tranvest_02`,
    
    -- Civils Jeunes Hommes
    `a_m_y_beachvesp_01`, `a_m_y_beachvesp_02`, `a_m_y_beach_01`, `a_m_y_beach_02`, `a_m_y_beach_03`,
    `a_m_y_bevhills_01`, `a_m_y_bevhills_02`, `a_m_y_breakdance_01`, `a_m_y_busicas_01`, `a_m_y_business_01`,
    `a_m_y_business_02`, `a_m_y_business_03`, `a_m_y_cyclist_01`, `a_m_y_dhill_01`, `a_m_y_downtown_01`,
    `a_m_y_eastsa_01`, `a_m_y_eastsa_02`, `a_m_y_epsilon_01`, `a_m_y_epsilon_02`, `a_m_y_gay_01`,
    `a_m_y_gay_02`, `a_m_y_genstreet_01`, `a_m_y_genstreet_02`, `a_m_y_golfer_01`, `a_m_y_hasjew_01`,
    `a_m_y_hiker_01`, `a_m_y_hipster_01`, `a_m_y_hipster_02`, `a_m_y_hipster_03`, `a_m_y_indian_01`,
    `a_m_y_jetski_01`, `a_m_y_juggalo_01`, `a_m_y_ktown_01`, `a_m_y_ktown_02`, `a_m_y_latino_01`,
    `a_m_y_methhead_01`, `a_m_y_mexthug_01`, `a_m_y_motox_01`, `a_m_y_motox_02`, `a_m_y_musclbeac_01`,
    `a_m_y_musclbeac_02`, `a_m_y_polynesian_01`, `a_m_y_roadcyc_01`, `a_m_y_runner_01`, `a_m_y_runner_02`,
    `a_m_y_salton_01`, `a_m_y_skater_01`, `a_m_y_skater_02`, `a_m_y_soucent_01`, `a_m_y_soucent_02`,
    `a_m_y_soucent_03`, `a_m_y_soucent_04`, `a_m_y_stbla_01`, `a_m_y_stbla_02`, `a_m_y_stlat_01`,
    `a_m_y_stwhi_01`, `a_m_y_stwhi_02`, `a_m_y_sunbathe_01`, `a_m_y_surfer_01`, `a_m_y_vindouche_01`,
    `a_m_y_vinewood_01`, `a_m_y_vinewood_02`, `a_m_y_vinewood_03`, `a_m_y_vinewood_04`, `a_m_y_yoga_01`,
    
    -- Civils Femmes
    `a_f_m_beach_01`, `a_f_m_bevhills_01`, `a_f_m_bevhills_02`, `a_f_m_bodybuild_01`, `a_f_m_business_02`,
    `a_f_m_downtown_01`, `a_f_m_eastsa_01`, `a_f_m_eastsa_02`, `a_f_m_fatbla_01`, `a_f_m_fatcult_01`,
    `a_f_m_fatwhite_01`, `a_f_m_ktown_01`, `a_f_m_ktown_02`, `a_f_m_prolhost_01`, `a_f_m_salton_01`,
    `a_f_m_skidrow_01`, `a_f_m_soucent_01`, `a_f_m_soucent_02`, `a_f_m_soucentmc_01`, `a_f_m_tourist_01`,
    `a_f_m_trampbeac_01`, `a_f_m_tramp_01`,
    
    -- Civils Jeunes Femmes
    `a_f_y_beach_01`, `a_f_y_bevhills_01`, `a_f_y_bevhills_02`, `a_f_y_bevhills_03`, `a_f_y_bevhills_04`,
    `a_f_y_business_01`, `a_f_y_business_02`, `a_f_y_business_03`, `a_f_y_business_04`, `a_f_y_cyclist_01`,
    `a_f_y_fitness_01`, `a_f_y_fitness_02`, `a_f_y_genhot_01`, `a_f_y_golfer_01`, `a_f_y_hiker_01`,
    `a_f_y_hipster_01`, `a_f_y_hipster_02`, `a_f_y_hipster_03`, `a_f_y_hipster_04`, `a_f_y_hippie_01`,
    `a_f_y_indian_01`, `a_f_y_juggalo_01`, `a_f_y_runner_01`, `a_f_y_rurmeth_01`, `a_f_y_scdressy_01`,
    `a_f_y_skater_01`, `a_f_y_soucent_01`, `a_f_y_soucent_02`, `a_f_y_soucent_03`, `a_f_y_tennis_01`,
    `a_f_y_topless_01`, `a_f_y_tourist_01`, `a_f_y_tourist_02`, `a_f_y_vinewood_01`, `a_f_y_vinewood_02`,
    `a_f_y_vinewood_03`, `a_f_y_vinewood_04`, `a_f_y_yoga_01`,
    
    -- Personnes Âgées
    `a_m_o_acult_01`, `a_m_o_acult_02`, `a_m_o_beach_01`, `a_m_o_genstreet_01`, `a_m_o_ktown_01`,
    `a_m_o_salton_01`, `a_m_o_soucent_01`, `a_m_o_soucent_02`, `a_m_o_soucent_03`, `a_m_o_tramp_01`,
    `a_f_o_genstreet_01`, `a_f_o_indian_01`, `a_f_o_ktown_01`, `a_f_o_salton_01`, `a_f_o_soucent_01`,
    `a_f_o_soucent_02`,
    
    -- Services/Travailleurs
    `s_m_m_ammucountry`, `s_m_m_autoshop_01`, `s_m_m_autoshop_02`, `s_m_m_bouncer_01`, `s_m_m_ccrew_01`,
    `s_m_m_chemwork_01`, `s_m_m_cntrybar_01`, `s_m_m_dockwork_01`, `s_m_m_doctor_01`, `s_m_m_fiboffice_01`,
    `s_m_m_fiboffice_02`, `s_m_m_gaffer_01`, `s_m_m_gardener_01`, `s_m_m_gentransport`, `s_m_m_hairdress_01`,
    `s_m_m_highsec_01`, `s_m_m_highsec_02`, `s_m_m_janitor`, `s_m_m_lathandy_01`, `s_m_m_lifeinvad_01`,
    `s_m_m_linecook`, `s_m_m_lsmetro_01`, `s_m_m_mariachi_01`, `s_m_m_marine_01`, `s_m_m_marine_02`,
    `s_m_m_migrant_01`, `s_m_m_movalien_01`, `s_m_m_movprem_01`, `s_m_m_movspace_01`, `s_m_m_paramedic_01`,
    `s_m_m_pilot_01`, `s_m_m_pilot_02`, `s_m_m_postal_01`, `s_m_m_postal_02`, `s_m_m_scientist_01`,
    `s_m_m_security_01`, `s_m_m_strperf_01`, `s_m_m_strpreach_01`, `s_m_m_strvend_01`, `s_m_m_trucker_01`,
    `s_m_m_ups_01`, `s_m_m_ups_02`,
    
    -- Services Jeunes
    `s_m_y_airworker`, `s_m_y_ammucity_01`, `s_m_y_armymech_01`, `s_m_y_autopsy_01`, `s_m_y_barman_01`,
    `s_m_y_baywatch_01`, `s_m_y_blackops_01`, `s_m_y_blackops_02`, `s_m_y_blackops_03`, `s_m_y_busboy_01`,
    `s_m_y_chef_01`, `s_m_y_clown_01`, `s_m_y_construct_01`, `s_m_y_construct_02`, `s_m_y_cop_01`,
    `s_m_y_dealer_01`, `s_m_y_devinsec_01`, `s_m_y_dockwork_01`, `s_m_y_doorman_01`, `s_m_y_dwservice_01`,
    `s_m_y_dwservice_02`, `s_m_y_factory_01`, `s_m_y_fireman_01`, `s_m_y_garbage`, `s_m_y_grip_01`,
    `s_m_y_hwaycop_01`, `s_m_y_marine_01`, `s_m_y_marine_02`, `s_m_y_marine_03`, `s_m_y_mime`,
    `s_m_y_pestcont_01`, `s_m_y_pilot_01`, `s_m_y_prismuscl_01`, `s_m_y_prisoner_01`, `s_m_y_ranger_01`,
    `s_m_y_robber_01`, `s_m_y_shop_mask`, `s_m_y_strvend_01`, `s_m_y_uscg_01`, `s_m_y_valet_01`,
    `s_m_y_waiter_01`, `s_m_y_winclean_01`, `s_m_y_xmech_01`, `s_m_y_xmech_02`,
    
    -- Services Femmes
    `s_f_m_fembarber`, `s_f_m_maid_01`, `s_f_m_shop_high`, `s_f_m_sweatshop_01`,
    `s_f_y_airhostess_01`, `s_f_y_bartender_01`, `s_f_y_baywatch_01`, `s_f_y_cop_01`, `s_f_y_factory_01`,
    `s_f_y_hooker_01`, `s_f_y_hooker_02`, `s_f_y_hooker_03`, `s_f_y_migrant_01`, `s_f_y_movprem_01`,
    `s_f_y_ranger_01`, `s_f_y_scrubs_01`, `s_f_y_sheriff_01`, `s_f_y_shop_low`, `s_f_y_shop_mid`,
    `s_f_y_stripper_01`, `s_f_y_stripper_02`, `s_f_y_stripperlite`, `s_f_y_sweatshop_01`,
    
    -- Gangs/Criminels
    `g_m_m_armboss_01`, `g_m_m_armgoon_01`, `g_m_m_armlieut_01`, `g_m_m_chemwork_01`, `g_m_m_chiboss_01`,
    `g_m_m_chicold_01`, `g_m_m_chigoon_01`, `g_m_m_chigoon_02`, `g_m_m_korboss_01`, `g_m_m_mexboss_01`,
    `g_m_m_mexboss_02`, `g_m_y_armgoon_02`, `g_m_y_azteca_01`, `g_m_y_ballaeast_01`, `g_m_y_ballaorig_01`,
    `g_m_y_ballasout_01`, `g_m_y_famca_01`, `g_m_y_famdnf_01`, `g_m_y_famfor_01`, `g_m_y_korean_01`,
    `g_m_y_korean_02`, `g_m_y_korlieut_01`, `g_m_y_lost_01`, `g_m_y_lost_02`, `g_m_y_lost_03`,
    `g_m_y_mexgang_01`, `g_m_y_mexgoon_01`, `g_m_y_mexgoon_02`, `g_m_y_mexgoon_03`, `g_m_y_pologoon_01`,
    `g_m_y_pologoon_02`, `g_m_y_salvaboss_01`, `g_m_y_salvagoon_01`, `g_m_y_salvagoon_02`, `g_m_y_salvagoon_03`,
    `g_m_y_strpunk_01`, `g_m_y_strpunk_02`,
    `g_f_y_ballas_01`, `g_f_y_families_01`, `g_f_y_lost_01`, `g_f_y_vagos_01`
}

-- Système de mémoire pour chaque PED
local function CreatePedMemory()
    return {
        seenPlayers = {},
        lastInteraction = 0,
        mood = math.random(1, 100),
        personality = math.random(1, 5),
        lastPosition = vector3(0, 0, 0),
        currentTask = "idle",
        threatLevel = 0,
        occupation = "civilian",
        spawnTime = GetGameTimer()
    }
end

-- Comportements dynamiques basés sur la personnalité
local behaviors = {
    [1] = { -- Timide
        approachDistance = 3.0,
        fleeChance = 0.7,
        talkChance = 0.2,
        wanderChance = 0.4
    },
    [2] = { -- Amical
        approachDistance = 1.5,
        fleeChance = 0.1,
        talkChance = 0.8,
        wanderChance = 0.6
    },
    [3] = { -- Neutre
        approachDistance = 2.5,
        fleeChance = 0.3,
        talkChance = 0.5,
        wanderChance = 0.5
    },
    [4] = { -- Agressif
        approachDistance = 1.0,
        fleeChance = 0.05,
        talkChance = 0.3,
        wanderChance = 0.3
    },
    [5] = { -- Peureux
        approachDistance = 5.0,
        fleeChance = 0.9,
        talkChance = 0.1,
        wanderChance = 0.7
    }
}

-- Détection optimisée des joueurs proches
local function GetNearbyPlayers(coords, radius)
    local players = {}
    local pls = GetActivePlayers()
    
    for i = 1, #pls do
        local ply = pls[i]
        local plyPed = GetPlayerPed(ply)
        local plyCoords = GetEntityCoords(plyPed)
        
        if #(coords - plyCoords) <= radius then
            players[#players + 1] = {
                id = ply,
                ped = plyPed,
                coords = plyCoords,
                vehicle = GetVehiclePedIsIn(plyPed, false)
            }
        end
    end
    
    return players
end

-- Système d'IA avancé
local function ProcessPedAI(ped, memory)
    if not DoesEntityExist(ped) or IsEntityDead(ped) then
        return false
    end
    
    local pedCoords = GetEntityCoords(ped)
    local nearbyPlayers = GetNearbyPlayers(pedCoords, config.visionRange)
    local behavior = behaviors[memory.personality]
    
    for _, player in ipairs(nearbyPlayers) do
        local distance = #(pedCoords - player.coords)
        local playerPed = player.ped
        
        local hasWeapon = IsPedArmed(playerPed, 7)
        local isShooting = IsPedShooting(playerPed)
        local isRunning = IsPedRunning(playerPed) or IsPedSprinting(playerPed)
        
        local threatLevel = 0
        if hasWeapon then threatLevel = threatLevel + 30 end
        if isShooting then threatLevel = threatLevel + 50 end
        if isRunning and distance < 10.0 then threatLevel = threatLevel + 20 end
        
        memory.threatLevel = threatLevel
        
        if threatLevel > 40 and math.random() < behavior.fleeChance then
            TaskSmartFleePed(ped, playerPed, 100.0, -1, false, false)
            memory.currentTask = "fleeing"
            memory.mood = math.max(0, memory.mood - 20)
            
        elseif threatLevel < 20 and distance < behavior.approachDistance then
            if math.random() < behavior.talkChance and memory.currentTask ~= "talking" then
                TaskStandStill(ped, math.random(3000, 8000))
                TaskTurnPedToFaceEntity(ped, playerPed, 2000)
                
                local animations = {
                    {dict = "gestures@m@standing@casual", anim = "gesture_hello"},
                    {dict = "mp_player_int_upperwave", anim = "mp_player_int_wave"},
                    {dict = "random@shop_tattoo", anim = "_idle_a"},
                    {dict = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base"},
                    {dict = "amb@world_human_stand_mobile@male@text@base", anim = "base"}
                }
                
                local anim = animations[math.random(#animations)]
                RequestAnimDict(anim.dict)
                while not HasAnimDictLoaded(anim.dict) do Wait(10) end
                TaskPlayAnim(ped, anim.dict, anim.anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                
                memory.currentTask = "talking"
                memory.lastInteraction = GetGameTimer()
                memory.mood = math.min(100, memory.mood + 10)
            end
            
        elseif distance > 15.0 and memory.currentTask == "idle" then
            if math.random() < behavior.wanderChance then
                TaskWanderInArea(ped, pedCoords.x, pedCoords.y, pedCoords.z, 20.0, 3.0, 5.0)
                memory.currentTask = "wandering"
            end
        end
        
        if isShooting then
            SetPedFleeAttributes(ped, 0, true)
            TaskReactAndFleePed(ped, playerPed)
        end
        
        memory.seenPlayers[player.id] = {
            lastSeen = GetGameTimer(),
            threat = threatLevel
        }
    end
    
    if memory.currentTask ~= "idle" and GetGameTimer() - memory.lastInteraction > 10000 then
        ClearPedTasks(ped)
        memory.currentTask = "idle"
    end
    
    return true
end

-- Spawn optimisé avec tous les modèles
local function SpawnIntelligentPed(coords, model)
    model = model or pedModels[math.random(#pedModels)]
    
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 100 do 
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(model) then
        return nil, nil
    end
    
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, math.random(0, 360), false, true)
    
    SetPedRandomComponentVariation(ped, true)
    SetPedRandomProps(ped)
    SetPedCanRagdollFromPlayerImpact(ped, true)
    SetPedCanRagdoll(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, false)
    
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 0, true)
    SetPedCombatAbility(ped, 100)
    SetPedCombatMovement(ped, 2)
    SetPedCombatRange(ped, 2)
    SetPedHearingRange(ped, config.hearingRange)
    SetPedSeeingRange(ped, config.visionRange)
    SetPedAlertness(ped, 3)
    
    local memory = CreatePedMemory()
    activeAI[ped] = memory
    spawnedPeds[#spawnedPeds + 1] = ped
    
    SetModelAsNoLongerNeeded(model)
    
    return ped, memory
end

-- Système de spawn automatique autour du joueur
local function AutoSpawnPeds()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    if #spawnedPeds < config.maxPeds then
        local spawnCount = math.min(5, config.maxPeds - #spawnedPeds)
        
        for i = 1, spawnCount do
            local angle = math.random() * 2 * math.pi
            local distance = math.random(50, config.spawnRadius)
            local offset = vector3(
                math.cos(angle) * distance,
                math.sin(angle) * distance,
                0
            )
            
            local spawnCoords = playerCoords + offset
            local z = 0.0
            local found, groundZ = GetGroundZFor_3dCoord(spawnCoords.x, spawnCoords.y, spawnCoords.z + 999.0, z, false)
            
            if found then
                spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)
                SpawnIntelligentPed(spawnCoords)
            end
        end
    end
end

-- Boucle principale optimisée
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local processedThisFrame = 0
        local maxPerFrame = 8
        
        for ped, memory in pairs(activeAI) do
            if processedThisFrame >= maxPerFrame then
                break
            end
            
            if DoesEntityExist(ped) then
                local pedCoords = GetEntityCoords(ped)
                local distance = #(playerCoords - pedCoords)
                
                if distance <= config.interactionDistance then
                    ProcessPedAI(ped, memory)
                    processedThisFrame = processedThisFrame + 1
                end
            else
                activeAI[ped] = nil
            end
        end
        
        Wait(config.updateInterval)
    end
end)

-- Spawn automatique continu
CreateThread(function()
    Wait(5000) -- Attente initiale
    
    while true do
        AutoSpawnPeds()
        Wait(10000) -- Spawn toutes les 10 secondes
    end
end)

-- Nettoyage automatique
CreateThread(function()
    while true do
        Wait(30000)
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for i = #spawnedPeds, 1, -1 do
            local ped = spawnedPeds[i]
            
            if DoesEntityExist(ped) then
                local distance = #(playerCoords - GetEntityCoords(ped))
                
                if distance > config.despawnRadius then
                    DeleteEntity(ped)
                    activeAI[ped] = nil
                    table.remove(spawnedPeds, i)
                end
            else
                activeAI[ped] = nil
                table.remove(spawnedPeds, i)
            end
        end
    end
end)

-- Commandes
RegisterCommand('spawnai', function(source, args)
    local count = tonumber(args[1]) or 1
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    for i = 1, math.min(count, 20) do
        local offset = vector3(math.random(-5, 5), math.random(-5, 5), 0)
        local spawnCoords = coords + offset
        SpawnIntelligentPed(spawnCoords)
    end
    
    QBXCore.Functions.Notify(count .. ' PED(s) IA créé(s)', 'success')
end)

RegisterCommand('clearai', function()
    for i = #spawnedPeds, 1, -1 do
        local ped = spawnedPeds[i]
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    spawnedPeds = {}
    activeAI = {}
    QBXCore.Functions.Notify('Tous les PEDs IA supprimés', 'success')
end)

RegisterCommand('aistats', function()
    QBXCore.Functions.Notify('PEDs actifs: ' .. #spawnedPeds .. '/' .. config.maxPeds, 'primary')
end)

RegisterCommand('autospawn', function(source, args)
    local toggle = args[1]
    if toggle == 'on' then
        config.maxPeds = 100
        QBXCore.Functions.Notify('Auto-spawn activé', 'success')
    else
        config.maxPeds = 0
        QBXCore.Functions.Notify('Auto-spawn désactivé', 'error')
    end
end)

-- Exports
exports('SpawnIntelligentPed', SpawnIntelligentPed)
exports('GetActivePeds', function() return spawnedPeds end)
exports('GetPedMemory', function(ped) return activeAI[ped] end)