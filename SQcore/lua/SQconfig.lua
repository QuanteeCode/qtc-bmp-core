local CLASS = {}
local configsPath = debug.getinfo(1).source:gsub("\\","/"):sub(2, -17) .. "configs/"

-- FUNCTIONS --

local function get(name)
    local filePath = configsPath .. name .. ".json"
    if (FS.IsFile(filePath)) then
        return Util.JsonDecode(SQutils.readFile(filePath))
    else
        return nil
    end
end

-- CLASS --

CLASS.get = get

return CLASS