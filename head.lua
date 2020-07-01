Head = Object:extend()
require "util"

function Head:new(base)
	self.id = base.id

	self.base = base

	self.x = base.x
	self.y = base.y
	self.z = base.z

	self.health = 100.0
end

function Head:update(dt)
	self.x = self.base.x
	self.y = self.base.y
	self.z = self.base.z
end

function Head:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.ellipse("line", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.2*Scale, 0.22*Scale)
end