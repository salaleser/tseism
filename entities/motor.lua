Motor = Object:extend()

function Motor:new(base)
	Motor.type = "Motor"

	Motor.taskMove = 1

	self.id = base.id
	self.type = Motor.type
	self.color = { 0, 0, 0.8, 1 }

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.base = base
	self.tasks = {}

	self.health = 100
	self.fatigue = 0
	self.speed = 10
end

function Motor:update(dt)
	self.x = self.base.x
	self.y = self.base.y
	self.z = self.base.z

	if self.fatigue > 0 then
		self.fatigue = self.fatigue - self.speed * dt
		if self.fatigue < 0 then
			self.fatigue = 0
		end
	end

	self:takeTask()

	local err = self:processTask()
	if err then
		Scale("ERROR: " .. self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. err)
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

	self:drawTarget()
end

function Motor:drawTarget()
	if self.task == nil
	or self.task.x == nil
	or self.task.y == nil then
		return
	end

	love.graphics.setColor(1, 0.5, 0.5, 0.5)
	love.graphics.setLineWidth(1)
	love.graphics.circle("line", self.task.x*Scale + Scale/2, self.task.y*Scale + Scale/2, 0.45*Scale)
end

function Motor:takeTask()
	for i, v in ipairs(Queue.queue) do
		if v.contractorId == self.id
		and v.contractorType == self.type then
			local task = table.remove(Queue.queue, i)
			table.insert(self.tasks, task)
			table.sort(self.tasks)
			Log:information(self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. "got a task \"" .. v.kind .. "\"")
		end
	end
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

		self.base.x = task.x
		self.base.y = task.y

		self.fatigue = self.fatigue + cost
	else
		return "cannot hanlde a task \"" .. task.kind .. "\""
	end
end