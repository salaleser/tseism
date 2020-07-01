Motor = Object:extend()
require "util"

function Motor:new(parent)
	self.id = NewGuid()

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.parent = parent

	self.health = 100.0
	self.speed = 50.0
end

function Motor:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z
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
	love.graphics.print("Speed: " .. self.speed, self.x*Scale + Scale, self.y*Scale + 12*1)
end