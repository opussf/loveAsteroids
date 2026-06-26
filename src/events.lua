local EventD = {}

EventD.__index = EventD

function EventD.new()
	local self = setmetatable({}, EventD)
	self.__events = {}
	print(self)
	return self
end
function EventD.register(self, eventName, callback)
	self.__events[eventName] = self.__events[eventName] or {}
	table.insert(self.__events[eventName], callback)
end
function EventD.fire(self, eventName, data)
	if self.__events[eventName] then
		for _, callback in ipairs(self.__events[eventName]) do
			callback(data)
		end
	end
end

return EventD
