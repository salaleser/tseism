Brain = Object:extend()
local pajarito = require "libs/pajarito"

function Brain:new(base, parent)
	self.id = base.id
	self.type = "Brain"
	self.color = { 0.8, 0.5, 0.7, 1 }

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.base = base
	self.parent = parent
	self.task = nil
	self.path = nil
	self.fieldOfView = {}
	self.fovLimit = 6

	self.hunger = 8.0
end

function Brain:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z

	self.hunger = self.hunger + 2 * dt

	if self.hunger > 10 then
		Queue:add(Task(self.id, "INTEL", "EAT", nil, nil))
	end

	self:takeTask()

	self:processTask()
end

function Brain:draw()

	-- draw brain
	local color = { 0.8, 0.5, 0.7, 0.5 }
	if self.task ~= nil then
		color = self.color
	end
	love.graphics.setColor(color)
	love.graphics.setLineWidth(1)
	love.graphics.ellipse("fill", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.14*Scale, 0.18*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y then
		Menu:append(self)
	end

	self:drawPath()
	self:drawFov()
end

function Brain:drawPath()
	if self.path == nil
	or #self.path < 2 then
		return
	end

	local x = self.path[#self.path].x*Scale + Scale/2
	local y = self.path[#self.path].y*Scale + Scale/2
	love.graphics.setColor(0.5, 1, 0.5, 0.5)
	love.graphics.circle("line", x, y, Scale/2)

	for i = 2, #self.path do
		local x1 = self.path[i-1].x*Scale + Scale/2
		local y1 = self.path[i-1].y*Scale + Scale/2
		local x2 = self.path[i].x*Scale + Scale/2
		local y2 = self.path[i].y*Scale + Scale/2
		love.graphics.line(x1, y1, x2, y2)
	end
end

function Brain:drawFov()
	if self.x ~= Cursor.selectedX
	or self.y ~= Cursor.selectedY
	or Scale < 16 then
		return
	end

	love.graphics.setColor(0, 1, 0, 0.15)
	local fovX1 = self.x - self.fovLimit
	local fovY1 = self.x + self.fovLimit
	local fovX2 = self.y - self.fovLimit
	local fovY2 = self.y + self.fovLimit
	for i = fovX1, fovY1 do
		for j = fovX2, fovY2 do
			love.graphics.rectangle("fill", i*Scale, j*Scale, Scale, Scale)
		end
	end
end

function Brain:takeTask()
	for i,v in ipairs(Queue) do
		if v.contractor == self.id
		and v.category == "INTEL" then
			self.task = v
			table.remove(Queue, i)
		end
	end
end

function Brain:processTask()
	if self.task == nil then
		return -1
	end

	if self.task.code == "EAT" then
		-- find some eatable entity
		local food = self:findFood()

		local target = food[1]

		-- make orders
		if self.x == target.x
		and self.y == target.y
		and self.z == target.z then
			-- eat food at self position
			Queue:add(Task(self.id, "HEAD", "EAT", nil, nil, target))
		else
			-- move at food position
			self:scanFovForObstacles()
			self.path = pajarito.pathfinder(self.x, self.y, target.x, target.y)
			if #self.path > 1 then
				Queue:add(Task(self.id, "MOTOR", "MOVE", self.path[2].x, self.path[2].y, nil))
			end
		end
	elseif self.task.code == "SATIATE" then
		self.hunger = self.hunger + 5
	end
end

function Brain:findFood()
	local food = {}

	local x1 = self.x - self.fovLimit
	local y1 = self.y - self.fovLimit
	local x2 = self.x + self.fovLimit
	local y2 = self.y + self.fovLimit
	for i = x1, y1 do
		for j = x2, y2 do
			for _, v in ipairs(Seeds) do
				if v.x == j and v.y == i then
					table.insert(food, v)
				else
					table.insert(food, v)
				end
			end
		end
	end

	return food
end

function Brain:scanFovForObstacles()
	local obstaclesMap = {}
	local x1 = self.x - self.fovLimit
	local y1 = self.y - self.fovLimit
	local x2 = self.x + self.fovLimit
	local y2 = self.y + self.fovLimit
	for i = x1, y1 do
		for j = x2, y2 do
			for _, v in ipairs(Blocks) do
				if v.x == j and v.y == i then
					table.insert(obstaclesMap, 0)
				else
					table.insert(obstaclesMap, 1)
				end
			end
		end
	end
	pajarito.init(obstaclesMap, self.fovLimit*2, self.fovLimit*2, true)
end