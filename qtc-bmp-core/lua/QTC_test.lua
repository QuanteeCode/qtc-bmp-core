function CmdTestFn(senderId, args)
    print("Hello from test FN")
    print(args)
end

QTC_commands.register("CmdTestFn", "test", "some test cmd")

-- function onPlayerJoiningEH(player_id)
--     print(player_id)
-- end
-- MP.RegisterEvent("onPlayerJoining", "onPlayerJoiningEH")

-- function onPlayerDisconnectEH(player_id)
--     print(player_id)
-- end
-- MP.RegisterEvent("onPlayerDisconnect", "onPlayerDisconnectEH")

--MP.GetPlayerIdentifiers(player_id)
--MP.GetPlayerName(player_id)
--MP.IsPlayerGuest(player_id)
--MP.GetPlayers()
--MP.DropPlayer(player_id, "REASON HERE")

-- cursor,errorString = SQdb.read([[SELECT id FROM clients WHERE beammp_id = '123123']])
-- row = cursor:fetch ({}, "a")
-- print(row)

-- local clientId = 1
-- local reason = ""
-- local stmt = SQdb.bind("INSERT INTO blockings (client_id, type, startedAt, endedAt, reason) VALUES (?,?,?,?,?)", clientId, "kick", "0000-00-00 00:00:00", "0000-00-00 00:00:00", reason)
-- local cursor,errorString = SQdb.write():execute(stmt)

-- local val = "2y";
-- local res = SQutils.calcBlockingDates(val)
-- print(os.date("%Y-%m-%d %H:%M:%S", res.startAt))
-- print(os.date("%Y-%m-%d %H:%M:%S", res.endAt))
