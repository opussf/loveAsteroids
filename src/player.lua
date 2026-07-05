-- player.lua

local Player = {}

Player.__index = Player

function Player.new(eventd, coords)
	local self = setmetatable({}, Player)
	self.__angle = 0
	self.__coords = coords and {coords[1], coords[2]} or {0,0}
	self.__turnrate = 3
	self.__eventd = eventd
	return self
end

function Player.update(self)
end
function Player.draw(self)
	love.graphics.setColor( 1, 1, 1, 1 )
	-- love.graphics.polygon("line", asteroids.player.coords)
end

return Player
