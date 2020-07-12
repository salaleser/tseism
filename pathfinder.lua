Pathfinder = Object:extend()

function Pathfinder:new()
	self.map = {}
	self.visible = false
	self.defaultValue = -1

	-- remove table element by its value
	local tr = function(t, v)
		for i = 1, #t do
			if t[i] == v then
				table.remove(t, i)
				break
			end
		end
	end

	self.pqueue = function()
		local t = {}
		-- a set of elements
		local set = {}
		-- a set of priorities paired with a elements
		local r_set = {}
		-- sorted list of priorities
		local keys = {}
		-- add element into storage and set its priority and sort keys
		local function addKV(k, v)
			set[k] = v
			if not r_set[v] then
				table.insert(keys, v)
				table.sort(keys)
				local k0 = {k}
				r_set[v] = k0
				setmetatable(k0, {
					__mode = 'v'
				})
			else
				table.insert(r_set[v], k)
			end
		end

		-- remove element from storage and sort keys
		local remove = function(k)
			local v = set[k]
			local prioritySet = r_set[v]
			tr(prioritySet, k)
			if #prioritySet < 1 then
				tr(keys, v)
				r_set[v] = nil
				table.sort(keys)
				set[k] = nil
			end
		end; t.remove = remove

		-- returns an element with  the lowest priority
		t.min = function()
			local priority = keys[1]
			if priority then
				return r_set[priority] or {}
			else
				return {}
			end
		end

		-- returns an element with the highest priority
		t.max = function()
			local priority = keys[#keys]
			if priority then
				return r_set[priority] or {}
			else
				return {}
			end
		end

		-- is this queue empty?
		t.empty = function()
			return #keys < 1
		end

		setmetatable(t, {
			__index = set,
			__newindex = function(t, k, v)
				if not set[k] then
					-- new element
					addKV(k, v)
				else
					-- existing element, change its priority
					remove(k)
					addKV(k, v)
				end
			end,
		})
		return t
	end
end

function Pathfinder:init()
	for i = 0, WorldSize.width do
		local layer = {}
		for j = 0, WorldSize.height do
			local row = {}
			for k = 0, WorldSize.depth do
				table.insert(row, self:cost(nil, {i, j, k}))
			end
			table.insert(layer, row)
		end
		table.insert(self.map, layer)
	end
	Minimap.map = self.map

	local t = {}
	-- Cantor pair function
	local function cantorPair(k1, k2)
		return 0.5 * (k1 + k2) * ((k1 + k2) + 1) + k2
	end
	setmetatable(t, {
		__index = function(_, k)
			if type(k) == "table" then
				local i = rawget(t, cantorPair(k[1] or 1, k[2] or 1))
				return i or self.defaultValue
			end
		end,
		__newindex = function(_, k, v)
			if type(k) == "table" then
				rawset(t, cantorPair(k[1] or 1, k[2] or 1), v)
			else
				rawset(t, k, v)
			end
		end,
	})
	return t
end

function Pathfinder:keypressed(key, scancode, isrepeat)
	if key == "b" then
		if self.visible then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function Pathfinder:draw()
	if not self.visible then
		return
	end

	self:drawMap()
end

function Pathfinder:drawMap()
	for i, row in pairs(self.map) do
		for j, cell in pairs(row) do
			if cell[Level+1] == math.huge then
				love.graphics.setColor({1, 0, 0, 0.4})
			elseif cell[Level+1] == 1 then
				love.graphics.setColor({0, 1, 0, 0.4})
			else
				love.graphics.setColor({1, 1, 0, 0.4})
			end
			love.graphics.rectangle("fill", (i - 1)*Scale, (j - 1)*Scale, Scale, Scale)
		end
	end
end

-- The reciepe from the book "Lua Game Development Cookbook"
function Pathfinder:find(start, goal)

	-- This recipe will use the tuple data structure to deine the point
	-- position. However, the Lua language doesn't offer a real tuple data
	-- structure, where each tuple element is uniquely deined by its content.
	-- The easiest way to achieve tuple uniqueness is to cache tuples by
	-- their values.
	-- The following lines of code will show you how to use the Cantor pairing
	-- function in tuple caching:
	local cellCache = {}
	local function cantorPair(k1, k2)
		return 0.5 * (k1 + k2) * ((k1 + k2) + 1) + k2
	end
	local function storeCells(...)
		for _, elm in ipairs {...} do
			cellCache[cantorPair(elm[1], elm[2])] = elm
		end
	end
	local function queryCell(p)
		local cp = cantorPair(p[1], p[2])
		local cell = cellCache[cp]
		if not cell then
			cell = p
			cellCache[cp] = cell
		end
		return cell
	end

	local directionSet = {
		{-1,-1}, { 0, 1}, { 1, 1},
		{-1, 0},          { 1, 0},
		{ 1,-1}, { 0,-1}, {-1, 1},
	}
	-- general form of neighbour iterator
	local function neighboursFn(p0)
		for _, direction in ipairs(directionSet) do
			local p1 = queryCell({p0[1] + direction[1], p0[2] + direction[2]})
			coroutine.yield(p1)
		end
		coroutine.yield()
	end
	-- returns specialized parametrical iterator
	local function neighbours(p0)
		return coroutine.wrap(function()
			return neighboursFn(p0)
		end)
	end

	-- Another important point of this algorithm is path reconstruction. The
	-- pathinding solver uses a graph-like data structure, where the starting
	-- point is at the root of the graph and the ending point is at one of the
	-- leaf nodes. Path reconstruction goes from the leaf node—ending point
	-- back to the root while storing the whole path in a list data structure:
	local function reconstructPath(cameFrom, goal)
		local totalPath = {goal}
		local current = cameFrom[goal]
		while current do
			table.insert(totalPath, current)
			current = cameFrom[current]
		end
		return totalPath
	end

	-- The pathinding algorithm uses simple heuristic functions to estimate
	-- which path is the best to take. You can use the Manhattan distance
	-- function to obtain the path cost estimation. The good thing is that
	-- it's easier to solve than the usual distance function with a square root.
	local function heuristicCostEstimate(p0, p1)
		return math.abs(p0[1] - p1[1]) + math.abs(p0[2] - p1[2])
	end

	-- initial state
	local frontier = self.pqueue()
	local cameFrom = {}
	local costSoFar = {
		[start] = 0,
	}
	frontier[start] = 0
	storeCells(start, goal)

	while not frontier.empty() do
		local current = assert((frontier.min())[1])
		-- are we at goal?
		if current == goal then
			return reconstructPath(cameFrom, goal)
		end
		-- remove current position from the frontier
		frontier.remove(current)
		-- look at neighbours
		for neighbour in neighbours(current) do
			local newCost = costSoFar[current] + self:cost(current, neighbour)
			if not costSoFar[neighbour]
			or (newCost < costSoFar[neighbour]) then
				costSoFar[neighbour] = newCost
				frontier[neighbour] = newCost + heuristicCostEstimate(goal, neighbour)
				cameFrom[neighbour] = current
			end
		end
	end
end

-- You'll need to get the cost of stepping to the neighbor cell as well.
-- This can be determined by the cost function that looks at the target
-- map cell to check whether there's a passage or a wall:
function Pathfinder:cost(p0, p1)
	local x = p1[1]
	local y = p1[2]
	local z = p1[3]
	if z == nil then
		z = Level
	end
	for _, v in pairs(Blocks) do
		if v.x == x
		and v.y == y
		and v.z == z then
			return v.cost
		end
	end

	return 1 -- normal step cost
end