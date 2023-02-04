local pluginName = "Test plugin"
local pluginVersion = "0.0.1.4"
local pluginPath = debug.getinfo(1).source:gsub("\\","/"):sub(1, -12)

function onInit()
    print("------ Start plugin initialization: " .. pluginName .. " [" .. pluginVersion .. "] ------")

    SQutils = require("SQutils");
    SQconfig = require("SQconfig");
    SQdb = require("SQdb");
    SQcommands = require("SQcommands");
    SQsettings = require("SQsettings");
    SQusers = require("SQusers");
    SQtest = require("SQtest");

    print("------ End plugin initialization: " .. pluginName .. " [" .. pluginVersion .. "] ------")
end