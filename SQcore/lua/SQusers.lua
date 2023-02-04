local config = SQconfig.getConfig("main")

function SQusers_getPlayerIdByName(name)
    local players = MP.GetPlayers()
    for k, v in pairs(players) do
        if (v == name) then
            return k
        end
    end
    return nil
end

function SQUser_onPlayerConnecting_EH(player_id)
    local isGuest = MP.IsPlayerGuest(player_id)
    if (config.guests_allowed == false and isGuest == true)  then
        MP.DropPlayer(player_id, "BeamMP guest account not allowed. Click 'logout' (left bottom corner) and then register an BeamMP account")
    else
        local nick = MP.GetPlayerName(player_id)
        -- ToDo check ban by name
    end
end
MP.RegisterEvent("onPlayerConnecting", "SQUser_onPlayerConnecting_EH")

--

function SQusers_Kick_CMD(senderId, args)
    local playerId = SQusers_getPlayerIdByName(args[1])

    if (type(playerId) == 'nil') then
        SQutils.responseMessage(senderId, "User with name \""..args[1].."\" not found!")
    else
        SQutils.responseMessage(senderId, "User with name \""..args[1].."\" kicked! Reason: " .. args[2])
        MP.DropPlayer(playerId, "You are kicked from the server. Reason: " .. args[2])
    end
end
SQcommands.register("SQusers_Kick_CMD", "kick", "Usage: /kick player_name \"reason\"")

function SQusers_Ban_CMD(senderId, args)
    local playerId = SQusers_getPlayerIdByName(args[1])

    if (type(playerId) == 'nil') then
        SQutils.responseMessage(senderId, "User with name \""..args[1].."\" not found!")
    else
        SQutils.responseMessage(senderId, "User with name \""..args[1].."\" banned! Reason: " .. args[2])
        MP.DropPlayer(playerId, "You are banned on the server. Reason: " .. args[2])
    end
end
SQcommands.register("SQusers_Ban_CMD", "ban", "Usage: /ban player_name 1 day \"reason\"")
