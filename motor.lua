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
	self.speed = 100.0
end

function Motor:update(dt)
	self.x = self.base.x
	self.y = self.base.y
	self.z = self.base.z

	Motor:manage()

	Debug = 0

	if self.task ~= nil then
		local angle = math.atan2(self.task.entity.x - self.x, self.task.entity.y - self.y)
		local cos = math.cos(angle)
		local sin = math.sin(angle)
		Debug = cos

		self.base.x = self.base.x + self.speed * cos * dt
		self.base.y = self.base.y + self.speed * sin * dt
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
	love.graphics.print("Cos: " .. Debug, self.x*Scale + Scale, self.y*Scale + 12*1)
end

function Motor.manage(self)
	for i,v in ipairs(Queue) do
		if v.contractor == self.id then
			self.task = v
			table.remove(Queue, i)
		end
	end
end