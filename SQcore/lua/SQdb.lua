local CLASS = {}
local luasql = require("luasql.mysql")
local config = SQconfig.get("db")
local env = assert(luasql.mysql())
local db = {}

if (config ~= nil) then
    db = {
        read = assert(env:connect(config.read.name, config.read.user, config.read.pass, config.read.host, config.read.port)),
        write = assert(env:connect(config.write.name, config.write.user, config.write.pass, config.write.host, config.write.port))
    }
end

-- FUNCTIONS --

local function bind(sql, ... )
    local clean = {}
    local arg = {...}
    sql = string.gsub(sql, "?", "%%s", 20)

    for i,v in ipairs(arg) do
      --clean[i] = ngx.quote_sql_str(ngx.unescape_uri(v))
      clean[i] = "\"" .. v .. "\""
    end

    --sql = db.read:escape(string.format(sql, table.unpack(clean)))
    sql = string.format(sql, table.unpack(clean))

    return sql
end

local function read()
    return db.read
end

local function write()
    return db.write
end

local function readExec(clause)
    return db.read:execute(clause)
end

local function writeExec(clause)
    return db.write:execute(clause)
end

-- CLASS --

CLASS.bind = bind
CLASS.read = read
CLASS.write = write

return CLASS
