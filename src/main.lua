asteroids = {}
asteroids.isRunning = true
asteroids.player = { angle = 0, coords = {} }
asteroids.bullets = { }
asteroids.asteroids = { }

asteroids.score = 0
asteroids.lives = 3

asteroids.bulletSpeed = 250  -- Good value seems to be about 250 ish?
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
	asteroids.updateAsteroids()
	asteroids.detectCollisions()
end
function love.keypressed( key, scancode, isrepeat )
	-- print( key, scancode, isrepeat )
	if key == "space" then
		asteroids.fireBullet(asteroids.player.angle)
	end
end
function love.draw()
	asteroids.drawPlayer()
	asteroids.drawBullets()
	asteroids.drawAsteroids()
end

-- asteroids

function asteroids.init()
	-- print(asteroids.width, asteroids.height)
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
		bullet.x = x; bullet.y = y
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
	-- print("fired: ", angle, love.timer.getTime() )
end

-- asteroids

function asteroids.updateAsteroids()
	if #asteroids.asteroids < 1 then  -- less than 1 asteroid
		local newCount = math.random(5)  -- 5?
		for a = 1, newCount do
			local x, y
			local pathAngle = math.random(360)
			local pathSpeed = math.random(51) + 9
			local side = math.random(4)

			if side == 1 then -- left
				x = math.random(100)
				y = math.random(asteroids.height)
			elseif side == 2 then -- top
				x = math.random(asteroids.width)
				y = math.random(100)
			elseif side == 3 then -- right
				x = asteroids.width - math.random(100)
				y = math.random(asteroids.height)
			else -- bottom (4)
				x = math.random(asteroids.width)
				y = asteroids.height - math.random(100)
			end
			local spinSpeed = 15

			print(a, pathAngle, side, x, y)
			asteroids.asteroids[#asteroids.asteroids+1] = {
					spinAngle = 0,
					spinSpeed = spinSpeed,
					spawned = love.timer.getTime(),
					x=x, y=y, pathAngle = pathAngle, pathSpeed = pathSpeed,
					size = 4, coords = {} }
		end
	end
	for ai, asteroid in ipairs( asteroids.asteroids ) do
		-- move
		local distance = asteroid.pathSpeed * (love.timer.getTime() - asteroid.spawned)
		local csTable, pc, ps = asteroids.angleTable[asteroid.pathAngle]
		c = csTable[1]; s = csTable[2]
		local x = asteroid.x + (distance * c)
		local y = asteroid.y + (distance * s)
		if x < 0 then asteroid.x = asteroids.width; asteroid.spawned = love.timer.getTime() end
		if x > asteroids.width then asteroid.x = 0; asteroid.spawned = love.timer.getTime() end
		if y < 0 then asteroid.y = asteroids.height; asteroid.spawned = love.timer.getTime() end
		if y > asteroids.height then asteroid.y = 0; asteroid.spawned = love.timer.getTime() end
		asteroid.px = x; asteroid.py = y

		-- rotate
		-- local rotate = asteroid.spinAngle + (asteroid.spinSpeed * (love.timer.getTime() - asteroid.spawned))
		-- if rotate < 0 then rotate = rotate + 360 end
		-- if rotate > 360 then rotate = rotate - 360 end

		-- csTable = asteroids.angleTable[rotate]
		-- c = csTable[1]; s = csTable[2]

		for i, coord in ipairs( asteroids.shapes.asteroid ) do
			asteroid.coords[((i-1)*2)+1] = x + (coord[1] * asteroid.size) -- + coord[1]*c - coord[2]*s
			asteroid.coords[((i-1)*2)+2] = y + (coord[2] * asteroid.size) -- + coord[1]*s + coord[2]*c
		end
		-- print(x, y, distance, rotate)
	end
end
function asteroids.drawAsteroids()
	for _, asteroid in ipairs( asteroids.asteroids ) do
		-- print(_, asteroid.spawned, asteroid.px, asteroid.py, asteroid.pathAngle)
		love.graphics.polygon("line", asteroid.coords )
	end
end

-- Collisions

function asteroids.detectCollisions()
	-- detect collisions from the asteroid perspective
	for ai = #asteroids.asteroids, 1, -1 do  -- in reverse to be able to modify
		a = asteroids.asteroids[ai]
		for bi = #asteroids.bullets, 1, -1 do  -- in reverse to be able to modify
			b = asteroids.bullets[bi]
			local distance = ((a.px-b.x)^2 + (a.py-b.y)^2)^0.5
			-- print(string.format("a: (%0.2f,%0.2f) b: (%0.2f,%0.2f) d: %0.2f %s", a.px, a.py, b.x, b.y, distance, distance < a.size*10))
			if distance < a.size*10 then
				table.remove( asteroids.bullets, bi )  -- destory bullet
				asteroids.asteroids[ai].size = a.size / 2 -- half asteroid
				print("hit", ai, a.size, asteroids.asteroids[ai].size )
				if asteroids.asteroids[ai].size < 1 then  -- destroy asteroid
					print("pop", ai)
					table.remove(asteroids.asteroids, ai)
				else -- spawn new astroid
					-- do a deep copy.
					na = {}
					for k,v in pairs(a) do
						na[k] = v
					end
					na.coords = {}
					for i, c in ipairs(a.coords) do
						na.coords[i] = c
					end
					na.x = na.px; na.y = na.py; na.spawned = love.timer.getTime()
					na.pathAngle = na.pathAngle + math.random(-45,45)
					asteroids.asteroids[#asteroids.asteroids+1] = na
					print("spawn", #asteroids.asteroids, a.pathAngle, na.pathAngle)
				end
			end
		end
		if ((a.px-asteroids.center[1])^2 + (a.py-asteroids.center[2])^2)^0.5 < a.size*10 then

		end
	end
end
