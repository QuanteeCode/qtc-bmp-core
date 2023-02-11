local CLASS = {}
local config = QTC_config.get("main")

-- FUNCTIONS --

local function getClient(nick)
    local stmt = QTC_db.bind("SELECT * FROM clients WHERE nick = ?", nick)
    local cursor,errorString = QTC_db.read():execute(stmt)
    local row = cursor:fetch ({}, "a")
    return row
end

local function getClientByPlayerId(playerId)
    local nick = MP.GetPlayerName(playerId)
    if (type(nick) == 'nil') then
        return nil
    else
        return getClient(nick)
    end
end

local function getClientByBeamMPID(beamMPID)
    local stmt = QTC_db.bind("SELECT * FROM clients WHERE beammp_id = ?", beamMPID)
    local cursor,errorString = QTC_db.read():execute(stmt)
    local row = cursor:fetch ({}, "a")
    return row
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
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        local client = getClient(nick)
        if (type(client) == nil) then
            --ToDo: if player is not in db
        else
            local now = os.date("%Y-%m-%d %H:%M:%S")
            local stmt = QTC_db.bind("INSERT INTO blockings (client_id, type, reason, startedAt, endedAt) VALUES (?,?,?,?,?)", client.id, "kick", reason, now, now)
            local cursor,errorString = QTC_db.write():execute(stmt)
        end
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_KICKED") .. ": " .. nick .. ". " .. QTC_lang.get("USER_REASON") .. ": " .. reason)
        MP.DropPlayer(playerId, reason)
    end
end

local function kickByName(senderId, nick, reason)
    local playerId = getPlayerIdByName(nick)
    if (type(playerId) == 'nil') then
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        kick(senderId, getPlayerIdByName(nick), reason)
    end
end

--

local function ban(senderId, playerId, reason, length)
    local nick = MP.GetPlayerName(playerId)
    if (type(playerId) == 'nil') then
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        local client = getClient(nick)
        if (type(client) == nil) then
            --ToDo: if player is not in db
        else
            local t = QTC_utils.calcBlockingDates(length)
            local starts = os.date("%Y-%m-%d %H:%M:%S", t.startAt)
            local ends = os.date("%Y-%m-%d %H:%M:%S", t.endAt)
            local stmt = QTC_db.bind("INSERT INTO blockings (client_id, type, reason, startedAt, endedAt) VALUES (?,?,?,?,?)", client.id, "ban", reason, starts, ends)
            local cursor,errorString = QTC_db.write():execute(stmt)
        end
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_BANNED") .. ": " .. nick .. ". " .. QTC_lang.get("USER_REASON") .. ": " .. reason)
        MP.DropPlayer(playerId, reason)
    end
end

local function banByName(senderId, nick, reason, length)
    local playerId = getPlayerIdByName(nick)
    if (type(playerId) == 'nil') then
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        ban(senderId, playerId, reason, length)
    end
end

--

local function mute(senderId, playerId, reason, length)
    local nick = MP.GetPlayerName(playerId)
    if (type(playerId) == 'nil') then
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_MUTED") .. ": " .. nick .. ". " .. QTC_lang.get("USER_REASON") .. ": " .. reason)
        -- ToDo: mute
    end
end

local function muteByName(senderId, nick, reason, length)
    local playerId = getPlayerIdByName(nick)
    if (type(playerId) == 'nil') then
        QTC_utils.responseMessage(senderId, QTC_lang.get("USER_NOT_FOUND") .. ": " .. nick)
    else
        mute(senderId, playerId, reason, length)
    end
end

-- EVENTS --

function SQUser_onPlayerAuth_EH(player_name, player_role, is_guest)
    if (config ~= nil) then
        if (config.guests_allowed == false and is_guest == true)  then
            local now = os.date("%Y-%m-%d %H:%M:%S")

            stmt = QTC_db.bind("INSERT INTO connects (nick, client_id, ip) VALUES (?,?)", player_name, nil, nil)
            cursor,errorString = QTC_db.write():execute(stmt)

            print(cursor)
            print(errorString)

            return QTC_lang.get("USER_GUEST_NOT_ALLOWED")
        end
    end
end
MP.RegisterEvent("onPlayerAuth", "SQUser_onPlayerAuth_EH")

function SQUser_onPlayerConnecting_EH(player_id)
    local nick = MP.GetPlayerName(player_id)
    local playerIdentifiers = MP.GetPlayerIdentifiers(player_id)
    local now = os.date("%Y-%m-%d %H:%M:%S")
    local stmt, cursor, errorString, row

    local client = getClientByBeamMPID(playerIdentifiers.beammp)
    if (client == nil) then
        stmt = QTC_db.bind("INSERT INTO clients (beammp_id, nick) VALUES (?,?)", playerIdentifiers.beammp, nick)
        cursor,errorString = QTC_db.write():execute(stmt)
        client = getClientByBeamMPID(playerIdentifiers.beammp)
    end

    if (client ~= nil) then
        stmt = QTC_db.bind("SELECT * FROM blockings WHERE client_id = ? AND endedAt > ? AND type = 'ban' AND canceled != 1", client.id, now)
        cursor,errorString = QTC_db.read():execute(stmt)
        row = cursor:fetch ({}, "a")
        if (row ~= nil) then
            MP.DropPlayer(player_id, QTC_lang.get("USER_YOU_BANNED_UNTIL"))
        end
    end
end
MP.RegisterEvent("onPlayerConnecting", "SQUser_onPlayerConnecting_EH")

-- COMMANDS --

function SQusers_Kick_CMD(senderId, args)
    kickByName(senderId, args[1], args[2])
end
QTC_commands.register("SQusers_Kick_CMD", "kick", "Usage: /kick player_name \"reason\"")

function SQusers_Ban_CMD(senderId, args)
    banByName(senderId, args[1], args[2], args[3])
end
QTC_commands.register("SQusers_Ban_CMD", "ban", "Usage: /ban player_name 1 day \"reason\"")

CLASS.getPlayerIdByName = getPlayerIdByName
CLASS.getClient = getClient
CLASS.getClientByPlayerId = getClientByPlayerId
CLASS.kick = kick
CLASS.kickByName = kickByName
CLASS.ban = ban
CLASS.banByName = banByName
CLASS.mute = mute
CLASS.muteByName = muteByName

return CLASS
