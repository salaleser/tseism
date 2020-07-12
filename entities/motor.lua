Motor = Object:extend()

function Motor:new(base)
	Motor.type = "Motor"

	Motor.taskMove = 1

	self.id = base.id
	self.type = Motor.type
	self.color = Color.blue

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.base = base

	self.tasks = {}
	self.fatigueTask = 0
	self.speedTask = 10

	self.health = 100
	self.fatigue = 0
	self.speed = 10
end

function Motor:update(dt)
	self.x = self.base.x
	self.y = self.base.y
	self.z = self.base.z

	if self.fatigueTask > 0 then
		self.fatigueTask = self.fatigueTask - self.speedTask * dt
		if self.fatigueTask < 0 then
			self.fatigueTask = 0
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

function Motor:draw()
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(3)
	love.graphics.line(
		self.x*Scale,
		self.y*Scale,
		self.x*Scale + Scale,
		self.y*Scale + Scale
	)
	love.graphics.line(
		self.x*Scale + Scale,
		self.y*Scale,
		self.x*Scale,
		self.y*Scale + Scale
	)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end

function Motor:takeTask()
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

function Motor:processTask()
	if #self.tasks == 0 then
		return
	end

	local task = table.remove(self.tasks)

	if task.kind == Motor.taskMove then
		local cost = 5
		if self.fatigue + cost > cost then
			return
		end

		self.base.x = task.target.x
		self.base.y = task.target.y
		-- self.base.z = task.target.z

		self.fatigue = self.fatigue + cost
	else
		return "cannot hanlde a task \"" .. task.kind .. "\""
	end
end