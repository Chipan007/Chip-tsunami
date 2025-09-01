Config = {}

-- List of restart times (hours in 24h format)
Config.RestartTimes = {0, 5, 12, 18} -- Default: 00:00, 05:00, 12:00, 18:00

-- Timezone offset from UTC (e.g., Johannesburg is UTC+2)
Config.TimezoneOffset = 2

-- Location name (for reference, not used in code)
Config.Location = 'Johannesburg, South Africa'

-- Time before restart to trigger tsunami events (in minutes)
Config.TsunamiWarningMinutes = 10
-- Siren repeat interval after initial warning (in minutes)
Config.SirenRepeatMinutes = 2
-- Enable thunderstorm during tsunami
Config.EnableThunderstorm = true
-- Enable electricity trip during tsunami
Config.EnableElectricityTrip = true
-- Siren sound name (change to your siren sound asset)
-- Siren sound name (should match your .ogg file name, without extension)
Config.SirenSound = 'tsunami_siren'

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Check every minute
        local time = os.date("!*t")
        local hour = (time.hour + Config.TimezoneOffset) % 24
        local minute = time.min

        for _, restartHour in ipairs(Config.RestartTimes) do
            local minutesToRestart = ((restartHour - hour + 24) % 24) * 60 - minute
            if minutesToRestart < 0 then minutesToRestart = minutesToRestart + 1440 end

            if minutesToRestart == 30 then
                -- Light rain
                TriggerClientEvent('av_weather:freeze', -1, true, nil, nil, 'RAIN', false)
            elseif minutesToRestart == 20 then
                -- Moderate rain
                TriggerClientEvent('av_weather:freeze', -1, true, nil, nil, 'RAIN', false)
            elseif minutesToRestart == 10 then
                -- Worst thunderstorm, blackout, siren
                TriggerClientEvent('av_weather:freeze', -1, true, nil, nil, 'THUNDER', true)
                TriggerClientEvent('tsunami:playSiren', -1)
            elseif minutesToRestart == 5 then
                -- Siren again
                TriggerClientEvent('tsunami:playSiren', -1)
            elseif minutesToRestart == 0 then
                -- Restore weather sync after restart
                TriggerClientEvent('av_weather:freeze', -1, false)
            end
        end
    end
end)
-- Server-side tsunami event handlers


RegisterNetEvent('tsunami:playSiren')
AddEventHandler('tsunami:playSiren', function()
    TriggerClientEvent('tsunami:playSiren', -1)
end)

RegisterNetEvent('tsunami:tripElectricity')
AddEventHandler('tsunami:tripElectricity', function()
    TriggerClientEvent('tsunami:tripElectricity', -1)
end)

RegisterNetEvent('tsunami:serverRestartWarning')
AddEventHandler('tsunami:serverRestartWarning', function()
    ExecuteCommand('stop av_weather')
end)

RegisterNetEvent('tsunami:serverRestartCancel')
AddEventHandler('tsunami:serverRestartCancel', function()
    ExecuteCommand('start av_weather')
end)
