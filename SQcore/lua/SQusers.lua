local CLASS = {}
local config = SQconfig.get("main")

-- FUNCTIONS --

local function getClientId(nick)
    local stmt = SQdb.bind("SELECT id FROM clients WHERE nick = ?", nick)
    local cursor,errorString = SQdb.read():execute(stmt)
    local row = cursor:fetch ({}, "a")
    return row
end

local function getClientIdByPlayerId(playerId)
    local nick = MP.GetPlayerName(playerId)
    if (type(nick) == 'nil') then
        return nil
    else
        return getClientId(nick)
    end
end

local function getPlayerIdByName(name)
    local players = MP.GetPlayers()
    for k, v in pairs(players) do
        if (v == name) then
            return k
        end
    end
    return nil
end

--

local function kick(senderId, playerId, reason)
    local nick = MP.GetPlayerName(playerId)

    if (type(reason) == "nil") then
        reason = ""
    end

    if (type(nick) == 'nil') then
        SQutils.responseMessage(senderId, SQlang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        local clent = getClientId(nick)
        if (type(clent) == nil) then
            --ToDo: if player is not in db
        else
            local now = os.date("%Y-%m-%d %H:%M:%S")
            local stmt = SQdb.bind("INSERT INTO blockings (client_id, type, reason, startedAt, endedAt) VALUES (?,?,?,?,?)", clent.id, "kick", reason, now, now)
            local cursor,errorString = SQdb.write():execute(stmt)
        end
        SQutils.responseMessage(senderId, SQlang.get("USER_KICKED") .. ": " .. nick .. ". " .. SQlang.get("USER_REASON") .. ": " .. reason)
        MP.DropPlayer(playerId, reason)
    end
end

local function kickByName(senderId, nick, reason)
    local playerId = getPlayerIdByName(nick)
    if (type(playerId) == 'nil') then
        SQutils.responseMessage(senderId, SQlang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        kick(senderId, getPlayerIdByName(nick), reason)
    end
end

--

local function ban(senderId, playerId, reason, length)
    local nick = MP.GetPlayerName(playerId)
    if (type(playerId) == 'nil') then
        SQutils.responseMessage(senderId, SQlang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        local clent = getClientId(nick)
        if (type(clent) == nil) then
            --ToDo: if player is not in db
        else
            local t = SQutils.calcBlockingDates(length)
            local starts = os.date("%Y-%m-%d %H:%M:%S", t.startAt)
            local ends = os.date("%Y-%m-%d %H:%M:%S", t.endAt)
            print(starts)
            print(ends)
            local stmt = SQdb.bind("INSERT INTO blockings (client_id, type, reason, startedAt, endedAt) VALUES (?,?,?,?,?)", clent.id, "ban", reason, starts, ends)
            local cursor,errorString = SQdb.write():execute(stmt)
        end
        SQutils.responseMessage(senderId, SQlang.get("USER_BANNED") .. ": " .. nick .. ". " .. SQlang.get("USER_REASON") .. ": " .. reason)
        MP.DropPlayer(playerId, reason)
    end
end

local function banByName(senderId, nick, reason, length)
    local playerId = getPlayerIdByName(nick)
    if (type(playerId) == 'nil') then
        SQutils.responseMessage(senderId, SQlang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        ban(senderId, playerId, reason, length)
    end
end

--

local function mute(senderId, playerId, reason, length)
    local nick = MP.GetPlayerName(playerId)
    if (type(playerId) == 'nil') then
        SQutils.responseMessage(senderId, SQlang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        SQutils.responseMessage(senderId, SQlang.get("USER_MUTED") .. ": " .. nick .. ". " .. SQlang.get("USER_REASON") .. ": " .. reason)
        -- ToDo: mute
    end
end

local function muteByName(senderId, nick, reason, length)
    local playerId = getPlayerIdByName(nick)
    if (type(playerId) == 'nil') then
        SQutils.responseMessage(senderId, SQlang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        mute(senderId, playerId, reason, length)
    end
end

-- EVENTS --

function SQUser_onPlayerConnecting_EH(player_id)
    local isGuest = MP.IsPlayerGuest(player_id)
    if (config ~= nil) then
        if (config.guests_allowed == false and isGuest == true)  then
            MP.DropPlayer(player_id, SQlang.get("USER_GUEST_NOT_ALLOWED"))
            return
        end
    end

    local nick = MP.GetPlayerName(player_id)
    -- ToDo check ban by name
end
MP.RegisterEvent("onPlayerConnecting", "SQUser_onPlayerConnecting_EH")

-- COMMANDS --

function SQusers_Kick_CMD(senderId, args)
    kickByName(senderId, args[1], args[2])
end
SQcommands.register("SQusers_Kick_CMD", "kick", "Usage: /kick player_name \"reason\"")

function SQusers_Ban_CMD(senderId, args)
    banByName(senderId, args[1], args[2], args[3])
end
SQcommands.register("SQusers_Ban_CMD", "ban", "Usage: /ban player_name 1 day \"reason\"")

CLASS.getPlayerIdByName = getPlayerIdByName
CLASS.getClientId = getClientId
CLASS.getClientIdByPlayerId = getClientIdByPlayerId
CLASS.kick = kick
CLASS.kickByName = kickByName
CLASS.ban = ban
CLASS.banByName = banByName
CLASS.mute = mute
CLASS.muteByName = muteByName

return CLASS
