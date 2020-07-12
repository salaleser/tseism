Brain = Object:extend()

function Brain:new(base, parent)
	Brain.type = "Brain"

	Brain.taskSatiate = 1
	Brain.taskFindFood = 2

	self.id = base.id
	self.type = Brain.type
	self.color = Color.cherry

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.base = base
	self.parent = parent
	self.path = {}
	self.fovLimit = 16

	self.tasks = {}
	self.fatigueTask = 0
	self.speedTask = 10

	self.hunger = 8
end

function Brain:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z

	if self.fatigueTask > 0 then
		self.fatigueTask = self.fatigueTask - self.speedTask * dt
		if self.fatigueTask < 0 then
			self.fatigueTask = 0
		end
	end

	self.hunger = self.hunger + 2 * dt

	if self.hunger > 10 then
		Queue:add(Task(self.id, Brain.type, Brain.taskFindFood, nil))
	end

	self:takeTask()

	local err = self:processTask()
	if err then
		Log:error(self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. err)
	end
end

function Brain:draw()
	local color = {0.8, 0.5, 0.7, 0.5}
	if #self.tasks > 0 then
		color = self.color
	end
	love.graphics.setColor(color)
	love.graphics.setLineWidth(1)
	love.graphics.ellipse("fill", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.14*Scale, 0.18*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
	end
	Menu:append(self) -->FIXME

	self:drawPath()
	self:drawFov()
end

function Brain:drawPath()
	if #self.path == 0 then
		return
	end

	love.graphics.setColor(0.5, 1, 0.5, 0.5)
	local endX = self.path[1][1]*Scale + Scale/2
	local endY = self.path[1][2]*Scale + Scale/2
	local startX = self.path[#self.path][1]*Scale + Scale/2
	local startY = self.path[#self.path][2]*Scale + Scale/2
	love.graphics.circle("line", endX, endY, 0.4*Scale)
	love.graphics.circle("fill", startX, startY, 0.2*Scale)
	for i = 2, #self.path do
		local previousX = self.path[i-1][1]*Scale + Scale/2
		local previousY = self.path[i-1][2]*Scale + Scale/2
		local currentX = self.path[i][1]*Scale + Scale/2
		local currentY = self.path[i][2]*Scale + Scale/2
		love.graphics.line(previousX, previousY, currentX, currentY)
	end
end

function Brain:drawFov()
	if self.x ~= Cursor.selectedX
	or self.y ~= Cursor.selectedY
	or Scale < 16 then
		return
	end

	love.graphics.setColor(0, 1, 0, 0.1)
	local r = self.fovLimit
	for i = self.x - r, self.x + r do
		for j = self.y - r, self.y + r do
			love.graphics.rectangle("fill", i*Scale, j*Scale, Scale, Scale)
		end
	end
end

function Brain:takeTask()
	local cost = 5
	if self.fatigueTask + cost > cost then
		return
	end

	for i, v in ipairs(Queue.queue) do
		if v.contractorId == self.id
		and v.contractorType == self.type then
			local task = table.remove(Queue.queue, i)
			table.insert(self.tasks, task)
			table.sort(self.tasks)
			Log:information(self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. "got a task \"" .. v.kind .. "\"")
		end
	end

	self.fatigueTask = self.fatigueTask + cost
end

function Brain:processTask()
	if #self.tasks == 0 then
		return
	end

	local task = table.remove(self.tasks)

	if task.kind == Brain.taskFindFood then
		local foods = self:findFood()
		if #foods == 0 then
			return "there is no food"
		end

		local food = foods[1]

		-- make orders
		if self.x == food.x
		and self.y == food.y
		and self.z == food.z then
			-- eat food at the self position
			self.path = {}
			Queue:add(Task(self.id, Head.type, Head.taskEat, food))
		else
			-- move at a food position
			self.path = Pathfinder:find({self.x, self.y}, {food.x, food.y})
			if #self.path > 0 then
				local position = Position(
					self.path[#self.path-1][1],
					self.path[#self.path-1][2],
					self.path[#self.path-1][3]
				)
				Queue:add(Task(self.id, Motor.type, Motor.taskMove, position))
			else
				return "cannot find a passable route to {" .. food.x .. "•" .. food.y .. "•" .. food.z .. "}"
			end
		end
	elseif task.kind == Brain.taskSatiate then
		self.hunger = self.hunger - 10
		Log:information(self.type .. " says: \"Hunger reduced for 10\"")
	else
		return "cannot hanlde a task \"" .. task.kind .. "\""
	end
end

-- try to find an eatable entity
function Brain:findFood()
	local food = {}

	local r = self.fovLimit
	for i = self.x - r, self.x + r do
		for j = self.y - r, self.y + r do
			for _, v in pairs(Seeds) do
				if v.x == i
				and v.y == j
				and v.z == self.z then
					table.insert(food, v)
				end
			end
		end
	end

	return food
end