local CLASS = {}
local configsPath = debug.getinfo(1).source:gsub("\\","/"):sub(2, -17) .. "configs/"

local function getConfig(name)
    local filePath = configsPath .. name .. ".json"
    if (FS.IsFile(filePath)) then
        return Util.JsonDecode(SQutils.readFile(filePath))
    else
        return nil
    end
end

CLASS.getConfig = getConfig

return CLASS