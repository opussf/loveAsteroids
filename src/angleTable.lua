asteroids.angleTable = {}

local function makeCS(t, angle)
	local csTable = {}
	csTable[1] = math.cos(math.rad(angle)) -- c
	csTable[2] = math.sin(math.rad(angle)) -- s
	rawset(t, angle, csTable)
	-- local count = 0
	-- for _ in pairs(t) do
	-- 	count = count + 1
	-- end
	-- print(angle, count)
	return csTable
end

setmetatable(asteroids.angleTable, {__index=makeCS})
