Motor = Object:extend()

function Motor:new(base)
	self.id = base.id
	self.type = "Motor"
	self.color = { 0, 0, 0.8, 1 }

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.base = base
	self.task = nil

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
		Log:append("ERROR: "..err.." ("..self.id..") ["..self.x.."•"..self.y.."•"..self.z.."]: ")
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
	for i, v in ipairs(Queue) do
		if v.contractor == self.id
		and v.category == "MOTOR" then
			self.task = v
			table.remove(Queue, i)
		end
	end
end

function Motor:processTask()
	if self.task == nil then
		return
	end

	if self.task.code == "MOVE" then
		local cost = 5
		if self.fatigue + cost > cost then
			return -10
		end

		self.base.x = self.task.x
		self.base.y = self.task.y

		self.fatigue = self.fatigue + cost
		self.task = nil
	end
end