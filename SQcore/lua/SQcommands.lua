local CLASS = {}
local CMDS = {}
local commandsPrefix = "/"
local eventPrefix = "sqc_"

-- FUNCTIONS -- 

local function getList()
    return CMDS
end

local function isRegistred(name)
    for k, v in pairs(CMDS) do
        if (v.name == name) then
            return k
        end
    end
    return nil
end

local function register(handler, name, description)
    if (isRegistred(name) == nil) then
        local cmd = {
            name = name,
            description = description,
        }
        table.insert(CMDS, cmd)
        print("[INFO] CMD registred: " .. name)
    else
        print("[ERROR] CMD already taken: " .. name)
    end
    MP.RegisterEvent(eventPrefix .. name, handler)
end

local function splitCmdToArgsArray(cmd)
    local args = {}
    local e = 0

    while true do
        local b = e+1
        b = cmd:find("%S",b)
        if b==nil then break end
        if cmd:sub(b,b)=="'" then
            e = cmd:find("'",b+1)
            b = b+1
        elseif cmd:sub(b,b)=='"' then
            e = cmd:find('"',b+1)
            b = b+1
        else
            e = cmd:find("%s",b+1)
        end
        if e==nil then e=#cmd+1 end
        table.insert(args, cmd:sub(b,e-1))
    end

    return args
end

local function commandsHandler(senderId, cmd)
    if (senderId == nil) or (senderId >= 0 and string.sub(cmd, 1, 1) == commandsPrefix) then
        
        local cmdParts = splitCmdToArgsArray(cmd)
        local cmdName = cmdParts[1]
        if (type(senderId) == 'number') then
            cmdName = string.sub(cmdName, 2)
        end 

        if isRegistred(cmdName) then
            local args = {}
            for k, v in pairs(cmdParts) do
                if (k > 1) then
                    table.insert(args, v)
                end
            end

            MP.TriggerGlobalEvent(eventPrefix .. cmdName, senderId, args)

            if (senderId == nil) then
                return "CMD found: " .. cmdName
            else
                return 1
            end
        end

    end
end

-- COMMANDS --

function chatCommandsHandler(senderId, senderName, cmd)
    return commandsHandler(senderId, cmd)
end
MP.RegisterEvent("onChatMessage", "chatCommandsHandler")

function consoleCommandsHandler(cmd)
    return commandsHandler(nil, cmd)
end
MP.RegisterEvent("onConsoleInput", "consoleCommandsHandler")

-- CLASS --

CLASS.getList = getList
CLASS.register = register
CLASS.isRegistred = isRegistred

return CLASS
