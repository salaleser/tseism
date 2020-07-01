Head = Object:extend()
require "util"

function Head:new(parent)
	self.id = NewGuid()

	self.parent = parent

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.health = 100.0
end

function Head:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z
end

function Head:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.ellipse("line", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.2*Scale, 0.22*Scale)
end