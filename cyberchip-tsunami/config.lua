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
