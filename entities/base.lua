Base = Object:extend()

function Base:new(x, y, z)
	Base.type = "Base"

	self.id = NewGuid()
	self.type = Base.type
	self.color = Color.gray

	self.birth = love.timer.getTime() - StartTime

	self.x = x
	self.y = y
	self.z = z

	self.health = 100
	self.hunger = 0
	self.fatigue = 0

	self.speed = 20

	self.path = {}
	self.fovLimit = 12
	self.rangeLimit = 16

	self.memory = nil

	self.tasks = {}
	self.hasTask = function(task)
		for _, v in pairs(self.tasks) do
			if v == task then
				return true
			end
		end
		return false
	end

	self.parts = {}
end

function Base:update(dt)
	for _, part in pairs(self.parts) do
		part.x = self.x
		part.y = self.y
		part.z = self.z
	end

	self.hunger = self.hunger + 2 * dt

	if self.hunger > 1 then
		if not self.hasTask(Task.findFoodAndEat) then
			table.insert(self.tasks, Task.findFoodAndEat)
		end
	end

	if self.fatigue > 0 then
		self.fatigue = self.fatigue - self.speed * dt
		if self.fatigue < 0 then
			self.fatigue = 0
		end
	end

	self:takeTask()

	local err = self:processTask()
	if err then
		Log:error(err)
	end
end

function Base:draw()
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(1)
	love.graphics.circle("line", self.x*Scale + Scale/2, self.y*Scale + Scale/2, 0.4*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end

	self:drawPath()
	self:drawFov()
end

function Base:takeTask()
	for i, v in ipairs(Queue.queue) do
		if v.contractorId == self.id
		and v.contractorType == self.type then
			local task = table.remove(Queue.queue, i)
			table.insert(self.tasks, task)
			Log:information(self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. "got a task \"" .. v.kind .. "\"")
		end
	end
end

function Base:processTask()
	if #self.tasks == 0 then
		return
	end

	local task = self.tasks[1]

	if task == Task.findFoodAndEat then
		if self.memory == nil then
			self.memory = self:findClosest(Seeds)
		end

		if self.memory == nil then
			return "there is no seeds"
		end

		local target = self.memory

		if self.x == target.x
		and self.y == target.y
		and self.z == target.z then
			self.path = {}
			self:eat(target)

			if target.health <= 0 then
				self.memory = nil
			end
		else
			self:moveTo(target)
		end

		if self.hunger <= 0 then
			table.remove(self.tasks, 1)
		end
	else
		return "cannot handle " .. task.type
	end
end

function Base:findClosest(list)
	local minRange = self.rangeLimit
	local result = nil
	for _, v in pairs(list) do
		if v.x == self.x
		and v.y == self.y
		and v.z == self.z then
			return v
		end

		if v.z == self.z
		and v.x >= self.x - self.fovLimit - 1
		and v.x <= self.x + self.fovLimit + 1
		and v.y >= self.y - self.fovLimit - 1
		and v.y <= self.y + self.fovLimit + 1 then
			-- love.window.showMessageBox(v.x, v.y, {"1"})
			local path = Pathfinder:find({self.x, self.y, self.z}, {v.x, v.y})
			-- love.window.showMessageBox(v.x, v.y, {"2"})
			if #path < minRange then
				minRange = #path
				result = v
			end
		end
	end

	return result
end

function Base:drawPath()
	if #self.path == 0 then
		return
	end

	love.graphics.setColor(0.5, 1, 0.5, 0.5)
	local endX = self.path[1][1]*Scale + Scale/2
	local endY = self.path[1][2]*Scale + Scale/2
	local startX = self.path[#self.path-1][1]*Scale + Scale/2
	local startY = self.path[#self.path-1][2]*Scale + Scale/2
	love.graphics.circle("line", endX, endY, 0.4*Scale)
	love.graphics.circle("fill", startX, startY, 0.2*Scale)
	for i = 3, #self.path do
		local previousX = self.path[i-2][1]*Scale + Scale/2
		local previousY = self.path[i-2][2]*Scale + Scale/2
		local currentX = self.path[i-1][1]*Scale + Scale/2
		local currentY = self.path[i-1][2]*Scale + Scale/2
		love.graphics.line(previousX, previousY, currentX, currentY)
	end
end

function Base:drawFov()
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

function Base:getPart(type)
	for _, part in pairs(self.parts) do
		if part == type then
			return part
		end
	end

	return nil
end

function Base:moveTo(target)
	local cost = 5
	if self.fatigue + cost > cost then
		return
	end

	self.path = Pathfinder:find({self.x, self.y, self.z}, {target.x, target.y})
	if #self.path > 1 then
		self.x = self.path[#self.path-1][1]
		self.y = self.path[#self.path-1][2]
		-- self.z = self.path[#self.path-1][3] -- TODO
	else
		Log:error("cannot find a passable route to {" .. target.x .. "•" .. target.y .. "•" .. target.z .. "}")
	end

	self.fatigue = self.fatigue + cost
end

function Base:eat(target)
	local cost = 5
	if self.fatigue + cost > cost then
		return
	end

	target.health = target.health - 30
	self.hunger = self.hunger - 3

	self.fatigue = self.fatigue + cost
end