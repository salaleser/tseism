Body = Object:extend()
require "util"

function Body:new(x, y, z)
	self.id = NewGuid()

	self.birth = love.timer.getTime() - StartTime

	self.x = x
	self.y = y
	self.z = z

	self.health = 100.0
end

function Body:update(dt)

end

function Body:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("line", self.x*Scale + Scale/2, self.y*Scale + Scale/2, 0.4*Scale)
	love.graphics.print("Health: " .. self.health, self.x*Scale + Scale, self.y*Scale + 12*0)
end