local pluginName = "Test plugin"
local pluginVersion = "0.0.1.1"
local pluginPath = debug.getinfo(1).source:gsub("\\","/"):sub(1, -12)

function onInit()
    print("------ Start plugin initialization: " .. pluginName .. " [" .. pluginVersion .. "] ------")

    SQutils = require("SQutils")
    SQconfig = require("SQconfig")
    SQlang = require("SQlang")
    SQdb = require("SQdb")
    SQcommands = require("SQcommands")
    SQsettings = require("SQsettings")
    SQusers = require("SQusers")
    SQtest = require("SQtest")

    --------- TEST ---------

    -- local clientId = 1
    -- local reason = ""
    -- local stmt = SQdb.bind("INSERT INTO blockings (client_id, type, startedAt, endedAt, reason) VALUES (?,?,?,?,?)", clientId, "kick", "0000-00-00 00:00:00", "0000-00-00 00:00:00", reason)
    -- local cursor,errorString = SQdb.write():execute(stmt)

    -- local val = "2y";
    -- local res = SQutils.calcBlockingDates(val)
    -- print(os.date("%Y-%m-%d %H:%M:%S", res.startAt))
    -- print(os.date("%Y-%m-%d %H:%M:%S", res.endAt))



    --------- TEST ---------

    print("------ End plugin initialization: " .. pluginName .. " [" .. pluginVersion .. "] ------")
end