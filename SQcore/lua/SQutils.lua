local CLASS = {}

-- FUNCTIONS -- 

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

local function calcBlockingDates(val)
   local dates = {}
   local min = 0
   local letter = ""
   local number

   local strLen = string.len(val)

   if (strLen > 1) then
       letter = string.sub(val, -1)
       if (tonumber(letter) == nil) then
           number = tonumber(string.sub(val, 1, strLen - 1))
       else
           number = tonumber(val)
       end
   else
       number = tonumber(val)
   end

   if (type(number) ~= 'nil') then
       min = number
   end

   if (letter == 'y') then
       min = min * 60 * 24 * 365
   elseif (letter == 'd') then
       min = min * 60 * 24
   else
       min = min
   end

   dates.startAt = os.time()
   dates.endAt = dates.startAt + min * 60
   return dates
end

-- CLASS --

CLASS.dump = dump
CLASS.readFile = readFile
CLASS.strSplit = strSplit
CLASS.responseMessage = responseMessage
CLASS.calcBlockingDates = calcBlockingDates

return CLASS