local CLASS = {}
local configsPath = debug.getinfo(1).source:gsub("\\","/"):sub(2, -20) .. "/configs/"

-- FUNCTIONS --

local function get(name)
    local filePath = configsPath .. name .. ".json"
    if (FS.IsFile(filePath)) then
        return Util.JsonDecode(QTC_utils.readFile(filePath))
    else
        return nil
    end
end

-- CLASS --

CLASS.get = get

return CLASS