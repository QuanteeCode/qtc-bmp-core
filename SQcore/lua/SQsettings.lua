function SQSettings_GetSettingsList_CMD(senderId, args)
    print(MP.Settings)
end
SQcommands.register("SQSettings_GetSettingsList_CMD", "SettingsList", "Show settings list")

function SQSettings_GetSettingsList_CMD(senderId, args)
    if (args[1] == 'private') then
        MP.Set(MP.Settings.Private, SQutils(args[2]))
    elseif (args[1] == 'debug') then
        MP.Set(MP.Settings.Debug, SQutils(args[2]))
    elseif (args[1] == 'name') then
        MP.Set(MP.Settings.Name, args[2])
    elseif (args[1] == 'description') then
        MP.Set(MP.Settings.Description, args[2])
    elseif (args[1] == 'maxplayers') then
        MP.Set(MP.Settings.MaxPlayers, tonumber(args[2]))
    elseif (args[1] == 'maxcars') then
        MP.Set(MP.Settings.MaxCars, tonumber(args[2]))
    elseif (args[1] == 'map') then
        MP.Set(MP.Settings.Map, args[2])
    else
       print("setting not found")
    end
end
SQcommands.register("SQSettings_GetSettingsList_CMD", "SettingsSet", "Set an setting")
