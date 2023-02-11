local CLASS = {}
local langsPath = debug.getinfo(1).source:gsub("\\","/"):sub(2, -15) .. "lang/"

-- FUNCTIONS -- 

local function get(name)
    local cfg = QTC_config.get('main')

    if(cfg ~= nil) then
        local filePath = langsPath .. cfg.lang .. ".json"
        if (FS.IsFile(filePath)) then
            local lang = Util.JsonDecode(QTC_utils.readFile(filePath))
            return lang[name]
        else
            return name
        end
    else
        return name
    end

end

-- CLASS --

CLASS.get = get

return CLASS