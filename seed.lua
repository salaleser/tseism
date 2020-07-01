Seed = Object:extend()
require "util"

function Seed:new(x, y, z)
	self.id = NewGuid()

	self.x = x
	self.y = y
	self.z = z
end

function Seed:update(dt)

end

function Seed:draw()
	love.graphics.setColor(1, 0.78, 0.15, 1)
	love.graphics.print("ID: " .. self.id, self.x*Scale + Scale, self.y*Scale + 12*-1)
	love.graphics.circle("fill", self.x*Scale + Scale/4, self.y*Scale + Scale/4, Scale/8)
end