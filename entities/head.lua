Head = Object:extend()

function Head:new(base)
	self.id = base.id
	self.type = "Head"

	self.base = base

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.health = 100.0
	self.fatigue = 0.0
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
		Log:append("ERROR: "..err.." ("..self.id..") ["..self.x.."•"..self.y.."•"..self.z.."]: ")
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
	for i, v in ipairs(Queue) do
		if v.contractor == self.id
		and v.category == "HEAD" then
			self.task = v
			table.remove(Queue, i)
		end
	end
end

function Head:processTask()
	if self.task == nil then
		return
	end

	if self.task.code == "EAT" then
		local cost = 5
		if self.fatigue + cost > cost then
			return -10
		end

		self.task.target.health = self.task.target.health - 20
		Queue:add(Task(self.id, "INTEL", "SATIATE"))

		self.fatigue = self.fatigue + cost
		self.task = nil
	end
end