Base = Object:extend()
require "util"

function Base:new(x, y, z)
	self.id = NewGuid()

	self.birth = love.timer.getTime() - StartTime

	self.x = x
	self.y = y
	self.z = z

	self.health = 100.0
end

function Base:update(dt)

end

function Base:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("line", self.x*Scale + Scale/2, self.y*Scale + Scale/2, 0.4*Scale)

	if self.x == Cursor.x
		and self.y == Cursor.y
		and Scale > 16 then
			love.graphics.print("ID: " .. self.id, self.x*Scale + Scale, self.y*Scale + 12*-1)
			love.graphics.print("Health: " .. self.health, self.x*Scale + Scale, self.y*Scale + 12*0)
	end
end