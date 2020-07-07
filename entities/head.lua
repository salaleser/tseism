Head = Object:extend()

function Head:new(base)
	Head.type = "Head"

	Head.taskEat = 1

	self.id = base.id
	self.type = Head.type

	self.base = base

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.tasks = {}

	self.health = 100
	self.fatigue = 0
	self.force = 2
end

function Head:update(dt)
	self.x = self.base.x
	self.y = self.base.y
	self.z = self.base.z

	if self.fatigue > 0 then
		self.fatigue = self.fatigue - self.force * dt
		if self.fatigue < 0 then
			self.fatigue = 0
		end
	end

	self:takeTask()

	local err = self:processTask()
	if err then
		Log:error(self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. err)
	end
end

function Head:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.ellipse("line", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.2*Scale, 0.22*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end

function Head:takeTask()
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

function Head:processTask()
	if #self.tasks == 0 then
		return
	end

	local task = table.remove(self.tasks)

	if task.kind == Head.taskEat then
		local cost = 1
		if self.fatigue + cost > cost then
			return
		end

		task.target.health = task.target.health - 20 -- directly!
		Queue:add(Task(self.id, Brain.type, Brain.taskSatiate))

		self.fatigue = self.fatigue + cost
	else
		return "cannot hanlde a task \"" .. task.kind .. "\""
	end
end