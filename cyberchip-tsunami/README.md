# chipanster Tsunami Script

A standalone FiveM tsunami/weather event script compatible with ESX, QBCore, and any other framework.

## Features
- Automatic tsunami/weather events before scheduled server restarts
- Blackout, thunderstorm, and siren effects
- Configurable restart times and timezone
- Integrates with av_weather for reliable weather control

## Installation

1. **Download and extract the resource folder** to your server's `resources` directory.

2. **Add the following to your `server.cfg`:**
   ```
   ensure chip-tsunami
   ```

3. **Configure your settings:**
   - Edit `config.lua` to set your restart times, timezone, and other options:
     ```lua
     Config.RestartTimes = {0, 5, 12, 18} -- Restart hours (24h format)
     Config.TimezoneOffset = 2 -- UTC offset (e.g., Johannesburg is 2)
     Config.SirenSound = 'tsunami_siren' -- .ogg file in sounds/
     ```


4. **Add your siren sound file:**
   - Place a siren `.ogg` file in the `sounds/` folder and name it as set in `config.lua` (default: `tsunami_siren.ogg`).
   - You must also add the same `.ogg` file to your InteractSound resource's `client/html/sounds/` folder.
   - Restart InteractSound after adding the sound file.

5. **Ensure av_weather is installed and running** for best weather/blackout effects.

## Usage
- The script will automatically trigger weather and siren events before each scheduled restart.
- You can manually test the tsunami event with the following client commands:
  - `/tsunami_test` — Start tsunami event
  - `/tsunami_stop` — Stop tsunami event

## Compatibility
- Works with ESX, QBCore, and standalone servers.
- No framework dependencies required.

## Support
For help or suggestions, open an issue or contact the author.
