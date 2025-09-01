local Config = Config or {}

local tsunamiActive = false
local sirenTimer = nil
local electricityTripped = false

function PlayTsunamiSiren()
    TriggerServerEvent('tsunami:playSiren')
end
RegisterNetEvent('tsunami:playSiren')
AddEventHandler('tsunami:playSiren', function()
    -- Play custom siren sound using InteractSound
    local sirenSound = Config.SirenSound or 'tsunami_siren'
    -- Volume: 1.0, Distance: 0 = all players
    TriggerEvent('InteractSound_CL:PlayOnAll', sirenSound, 1.0)
end)

function TripElectricity()
    TriggerServerEvent('tsunami:tripElectricity')
end
-- Client event: Simulate blackout (all lights except vehicles)
RegisterNetEvent('tsunami:tripElectricity')
AddEventHandler('tsunami:tripElectricity', function()
    print('[Tsunami] Blackout event triggered: using av_weather freeze for blackout.')
    -- Use av_weather to force blackout for all players
    TriggerEvent('av_weather:freeze', true, nil, nil, nil, true)
end)

-- Utility: Set worst thunderstorm
function SetWorstThunderstorm()
    -- Use av_weather to set thunderstorm and blackout
    TriggerEvent('av_weather:freeze', true, nil, nil, 'THUNDER', true)
end

-- Main tsunami event logic
function StartTsunamiEvent()
    if tsunamiActive then return end
    tsunamiActive = true
    if Config.EnableThunderstorm then SetWorstThunderstorm() end
    if Config.EnableElectricityTrip and not electricityTripped then
        -- blackout is handled by av_weather:freeze in SetWorstThunderstorm
        electricityTripped = true
    end
    PlayTsunamiSiren()
    sirenTimer = Citizen.CreateThread(function()
        while tsunamiActive do
            Citizen.Wait(Config.SirenRepeatMinutes * 60000)
            PlayTsunamiSiren()
        end
    end)
end

function StopTsunamiEvent()
    tsunamiActive = false
    electricityTripped = false
    -- Weather will be restored by av_weather:freeze below
    if sirenTimer then
        -- No need to kill thread; it will exit naturally when tsunamiActive is false
        sirenTimer = nil
    end
    -- Restore normal weather sync after tsunami ends
    TriggerEvent('av_weather:freeze', false)
end

RegisterNetEvent('tsunami:serverRestartWarning')
AddEventHandler('tsunami:serverRestartWarning', function()
    StartTsunamiEvent()
end)

RegisterNetEvent('tsunami:serverRestartCancel')
AddEventHandler('tsunami:serverRestartCancel', function()
    StopTsunamiEvent()
end)

-- Manual test commands (client-side)
RegisterCommand('tsunami_test', function()
    TriggerEvent('tsunami:serverRestartWarning')
    TriggerEvent('chat:addMessage', { args = { '^3Tsunami', 'Tsunami event started (test).' } })
end, false)

RegisterCommand('tsunami_stop', function()
    TriggerEvent('tsunami:serverRestartCancel')
    TriggerEvent('chat:addMessage', { args = { '^3Tsunami', 'Tsunami event stopped (test).' } })
end, false)



RegisterNetEvent('txAdmin:events:scheduledRestart')
AddEventHandler('txAdmin:events:scheduledRestart', function(data)
    -- data.secondsRemaining gives seconds until restart
    local minutesRemaining = math.floor((data.secondsRemaining or 0) / 60)
    if minutesRemaining <= Config.TsunamiWarningMinutes then
        TriggerEvent('tsunami:serverRestartWarning')
    end
    -- Progressive weather escalation using av_weather
    if minutesRemaining <= 30 and minutesRemaining > 20 then
        -- Light rain
        TriggerEvent('av_weather:freeze', true, nil, nil, 'RAIN', false)
    elseif minutesRemaining <= 20 and minutesRemaining > 10 then
        -- Moderate rain
        TriggerEvent('av_weather:freeze', true, nil, nil, 'RAIN', false)
    elseif minutesRemaining <= 10 and minutesRemaining > 0 then
        -- Worst thunderstorm and blackout
        TriggerEvent('av_weather:freeze', true, nil, nil, 'THUNDER', true)
    end
end)
