asteroids = {}
asteroids.isRunning = true
asteroids.angleTable = {}
asteroids.player = { angle = 0, coords = {} }


require "shapes"

-- love functions

function love.load()
	math.randomseed( os.time() )

	asteroids.width, asteroids.height = love.graphics.getDimensions()
	asteroids.center = {asteroids.width/2, asteroids.height/2}
	-- asteroids.background = love.graphics.newCanvas( asteroids.width, asteroids.height )
	-- love.graphics.setCanvas( asteroids.background )
	-- 	love.graphics.clear( 0, 0, 0, 0 )
	-- 	love.graphics.setBlendMode( "alpha" )
	-- love.graphics.setCanvas()

	asteroids.init()

	-- love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineStyle("rough")  -- or "smooth"

end
function love.update( dt )
	if love.keyboard.isDown("left") then
		asteroids.updatePlayerAngle("left")
	end
	if love.keyboard.isDown("right") then
		asteroids.updatePlayerAngle("right")
	end
	 -- asteroids.drawPlayer()

end
function love.keypressed( key, scancode, isrepeat )
	print( key, scancode, isrepeat )
	if key == "space" then
		print("FIRE!")
	end
end
function love.draw()
	asteroids.drawPlayer()
end

-- asteroids

function asteroids.init()
	print(asteroids.width, asteroids.height)
	asteroids.playerSetPoints()
	asteroids.drawPlayer()
end
function asteroids.updatePlayerAngle(key)
	if key == "left" then
		asteroids.player.angle = asteroids.player.angle - 1
	elseif key == "right" then
		asteroids.player.angle = asteroids.player.angle + 1
	end
	if asteroids.player.angle>=360 then
		asteroids.player.angle = 0
	end
	if asteroids.player.angle < 0 then
		asteroids.player.angle = 359
	end
	asteroids.playerSetPoints()
end
function asteroids.playerSetPoints()
	print(asteroids.player.angle)
	local csTable,c,s = asteroids.angleTable[asteroids.player.angle]

	if csTable == nil then
		c = math.cos(math.rad(asteroids.player.angle))
		s = math.sin(math.rad(asteroids.player.angle))
		csTable = {c,s}
		asteroids.angleTable[asteroids.player.angle] = csTable
	end
	c = csTable[1]; s = csTable[2]
	print(asteroids.player.angle,csTable, c, s)
	for i, coord in ipairs( asteroids.shapes.player ) do
		print(i, ((i-1)*2)+1, ((i-1)*2)+2 )
		asteroids.player.coords[((i-1)*2)+1] = asteroids.center[1] + coord[1]*c - coord[2]*s -- x'
		asteroids.player.coords[((i-1)*2)+2] = asteroids.center[2] + coord[1]*s + coord[2]*c -- y'
	end
end

function asteroids.drawPlayer()
	love.graphics.setColor( 1, 1, 1, 1 )
	love.graphics.polygon("line", asteroids.player.coords)
end
