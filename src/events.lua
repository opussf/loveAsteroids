local EventD = {}

EventD.__index = EventD

function EventD.new()
	local self = setmetatable({}, EventD)
	self.__events = {}
	self.__eventlog = {}
	return self
end
function EventD.__log(self, eventName, data)
	table.insert(self.__eventlog,{os.time(), eventName, data})
end
function EventD.getlog(self)
	local logout = {}
	for _, entry in ipairs(self.__eventlog) do
		local logtable = {entry[1], entry[2]}
		for k,v in pairs(entry[3]) do
			table.insert(logtable, k..":"..v)
		end
		table.insert(logout, table.concat(logtable, " "))
	end
	return( table.concat(logout, "\n"))
end
function EventD.register(self, eventName, callback)
	self.__events[eventName] = self.__events[eventName] or {}
	table.insert(self.__events[eventName], callback)
end
function EventD.fire(self, eventName, data)
	self:__log(eventName, data)
	if self.__events[eventName] then
		for _, callback in ipairs(self.__events[eventName]) do
			callback(data)
		end
	end
end

return EventD
