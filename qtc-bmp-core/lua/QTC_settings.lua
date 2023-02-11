function QTC_SettingsGetSettingsList_CMD(senderId, args)
    print(MP.Settings)
end
QTC_commands.register("QTC_SettingsGetSettingsList_CMD", "SettingsList", "Show settings list")

function QTC_SettingsGetSettingsList_CMD(senderId, args)
    if (args[1] == 'private') then
        MP.Set(MP.Settings.Private, QTC_utils(args[2]))
    elseif (args[1] == 'debug') then
        MP.Set(MP.Settings.Debug, QTC_utils(args[2]))
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
       print(QTC_lang.get("SETTING_NOT_FOUND"))
    end
end
QTC_commands.register("QTC_SettingsGetSettingsList_CMD", "SettingsSet", "Set an setting")
