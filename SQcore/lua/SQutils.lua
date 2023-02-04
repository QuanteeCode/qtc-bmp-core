local CLASS = {}

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function toBool(val)
   local bool = true
   if (val == false) or (val == "false") or (val == 0) or (val == nil) then
       bool = false
   end
   return bool
end

local function readFile(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function strSplit(string, delimeter)
   --"%S+"
   chunks = {}
   for substring in string:gmatch(delimeter) do
      table.insert(chunks, substring)
   end
   return chunks
end

local function responseMessage(senderId, msg)
   if (type(senderId) == 'nil') then
      print(msg)
  else
      MP.SendChatMessage(senderId, msg)
  end
end

CLASS.dump = dump
CLASS.readFile = readFile
CLASS.strSplit = strSplit
CLASS.responseMessage = responseMessage

return CLASS