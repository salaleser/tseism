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

	self:drawStats()
end

function Base:drawStats()
	if self.x ~= Cursor.x
	or self.y ~= Cursor.y
	or Scale < 16 then
		return -1
	end

	love.graphics.setColor(1, 1, 1, 0.6)
	love.graphics.print("ID: "..self.id, (self.x + 0)*Scale, (self.y + 0)*Scale - Scale/2)
end