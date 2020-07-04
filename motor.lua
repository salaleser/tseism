Motor = Object:extend()
require "util"

function Motor:new(base)
	self.id = base.id

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.base = base
	self.task = nil

	self.health = 100.0
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

	self:manage()

	if self.task ~= nil then
		local err = self:act()
		if err == -1 then
			love.window.showMessageBox("ERROR", "local err = self:act()", {"OK"})
		end
	end
end

function Motor:draw()
	love.graphics.setColor(0, 0, 1, 1)
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
	love.graphics.line(
		self.x*Scale,
		self.y*Scale + Scale/2,
		self.x*Scale + Scale,
		self.y*Scale + Scale/2
	)

	love.graphics.print("Fatigue: "..self.fatigue, self.x*Scale + Scale, self.y*Scale + 12*3)
	local task = "Task: "
	if self.task ~= nil then
		task = task..self.task.category..":"..self.task.code
		if self.task.entity ~= nil then
			task = task.." ("..self.task.entity.x.."/"..self.task.entity.y..")"
		end
		love.graphics.print(task, self.x*Scale + Scale, self.y*Scale)
	end
end

function Motor:manage()
	for i,v in ipairs(Queue) do
		if v.contractor == self.id
		and v.category == "MOTOR" then
			self.task = v
			table.remove(Queue, i)
		end
	end
end

function Motor:act()
	if self.task.code == "MOVE" then
		if self.task.x == nil or self.task.y == nil then
			love.window.showMessageBox("ERROR", "self.task.x == nil or self.task.y == nil", {"OK"})
			return -1
		end

		self:move(self.task.x, self.task.y)
	end
end

function Motor:move(x, y)
	local cost = 5
	if self.fatigue + cost > cost then
		return -10
	end

	self.base.x = x
	self.base.y = y

	self.fatigue = self.fatigue + cost
	self.task = nil
end