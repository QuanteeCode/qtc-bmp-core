local pluginName = "qtc_bmp_core"
local pluginVersion = "0.0.1.1"
local pluginPath = debug.getinfo(1).source:gsub("\\","/"):sub(1, -14)

function onInit()
    print("------ Start plugin initialization: " .. pluginName .. " [" .. pluginVersion .. "] ------")

    QTC_utils = require("QTC_utils")
    QTC_config = require("QTC_config")
    QTC_lang = require("QTC_lang")
    QTC_db = require("QTC_db")
    QTC_commands = require("QTC_commands")
    QTC_settings = require("QTC_settings")
    QTC_users = require("QTC_users")
    QTC_test = require("QTC_test")

    --------- TEST ---------



    --------- TEST ---------

    print("------ End plugin initialization: " .. pluginName .. " [" .. pluginVersion .. "] ------")
end