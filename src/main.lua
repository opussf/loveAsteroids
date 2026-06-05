asteroids = {}
asteroids.isRunning = true
asteroids.player = { angle = 0, coords = {} }
asteroids.bullets = { }
asteroids.asteroids = { }

asteroids.bulletSpeed = 250  -- Good value seems to be about 200 ish?
asteroids.turnRate = 3

require "angleTable"
require "shapes"

-- love functions

function love.load()
	math.randomseed( os.time() )

	asteroids.width, asteroids.height = love.graphics.getDimensions()
	asteroids.center = {asteroids.width/2, asteroids.height/2}

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
	-- if love.keyboard.isDown("space") then
	-- 	asteroids.fireBullet(asteroids.player.angle)
	-- end
	asteroids.updateBullets()
end
function love.keypressed( key, scancode, isrepeat )
	print( key, scancode, isrepeat )
	if key == "space" then
		asteroids.fireBullet(asteroids.player.angle)
	end
end
function love.draw()
	asteroids.drawPlayer()
	asteroids.drawBullets()
end

-- asteroids

function asteroids.init()
	print(asteroids.width, asteroids.height)
	asteroids.playerSetPoints()
	asteroids.drawPlayer()
end
function asteroids.updatePlayerAngle(key)
	if key == "left" then
		asteroids.player.angle = asteroids.player.angle - asteroids.turnRate
	elseif key == "right" then
		asteroids.player.angle = asteroids.player.angle + asteroids.turnRate
	end
	if asteroids.player.angle>=360 then
		asteroids.player.angle = 0
	end
	if asteroids.player.angle < 0 then
		asteroids.player.angle = 359
	end
	asteroids.playerSetPoints()
	asteroids.updateBullets()
end
function asteroids.playerSetPoints()
	-- see angleTable for the default setup
	local csTable,c,s = asteroids.angleTable[asteroids.player.angle]

	c = csTable[1]; s = csTable[2]
	-- print(asteroids.player.angle,csTable, c, s)
	for i, coord in ipairs( asteroids.shapes.player ) do
		asteroids.player.coords[((i-1)*2)+1] = asteroids.center[1] + coord[1]*c - coord[2]*s -- x'
		asteroids.player.coords[((i-1)*2)+2] = asteroids.center[2] + coord[1]*s + coord[2]*c -- y'
	end
end
function asteroids.drawPlayer()
	love.graphics.setColor( 1, 1, 1, 1 )
	love.graphics.polygon("line", asteroids.player.coords)
end

-- bullets

function asteroids.updateBullets()
	local distance, csTable, c, s, x, y
	for b = #asteroids.bullets, 1, -1 do
		-- print(#asteroids.bullets)
		local bullet = asteroids.bullets[b]
		distance = asteroids.bulletSpeed * (love.timer.getTime() - bullet.fired)
		csTable = asteroids.angleTable[bullet.angle]
		c, s = csTable[1], csTable[2]
		x = asteroids.center[1] + (distance * c)
		y = asteroids.center[2] + (distance * s)
		if x>asteroids.width or x<0 or y>asteroids.height or y<0 then
			table.remove(asteroids.bullets, b)
		else
			-- print(b,distance, x, y)
			for i, coord in ipairs( asteroids.shapes.bullet ) do
				bullet.coords[((i-1)*2)+1] = x + coord[1]
				bullet.coords[((i-1)*2)+2] = y + coord[2]
			end
		end
	end
end

function asteroids.drawBullets()
	for b, bullet in ipairs( asteroids.bullets ) do
		love.graphics.polygon("line", bullet.coords)
	end
end

function asteroids.fireBullet( angle )
	asteroids.bullets[#asteroids.bullets+1] = { angle = angle, fired = love.timer.getTime( ), x=0, y=0, coords = {} }
	print("fired: ", angle, love.timer.getTime() )

end