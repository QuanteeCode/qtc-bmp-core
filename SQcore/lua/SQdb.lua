local CLASS = {}
local luasql = require("luasql.mysql");
local config = SQconfig.getConfig("db")
local env = assert(luasql.mysql())
local db = {
    read = assert(env:connect(config.read.name, config.read.user, config.read.pass, config.read.host, config.read.port)),
    write = assert(env:connect(config.write.name, config.write.user, config.write.pass, config.write.host, config.write.port))
}

local function read(clause)
    return db.read:execute(clause)
end

local function write(clause)
    return db.write:execute(clause)
end

CLASS.read = read
CLASS.write = write

return CLASS
