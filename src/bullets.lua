-- bullets.lua

local Bullet = {}

Bullet.__index = Bullet

function Bullet.new()
	local self = setmetatable({}, Bullet)
	self.__events = {}
	self.__eventlog = {}
	return self
end

return Bullet