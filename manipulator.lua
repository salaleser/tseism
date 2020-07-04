Manipulator = Object:extend()
require "util"

function Manipulator:new(base)
	self.id = base.id

	self.base = base

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.health = 100.0
end

function Manipulator:update(dt)
	self.x = self.base.x
	self.y = self.base.y
	self.z = self.base.z
end

function Manipulator:draw()
	love.graphics.setColor(0.2, 0.4, 1, 1)
	love.graphics.setLineWidth(3)
	love.graphics.line(
		self.x*Scale,
		self.y*Scale + Scale/2,
		self.x*Scale + Scale,
		self.y*Scale + Scale/2
	)
end