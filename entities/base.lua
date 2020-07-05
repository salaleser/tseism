Base = Object:extend()

function Base:new(x, y, z)
	self.id = NewGuid()
	self.type = "Base"
	self.color = {0.7, 0.7, 0.7, 1}

	self.birth = love.timer.getTime() - StartTime

	self.x = x
	self.y = y
	self.z = z

	self.health = 100.0
end

function Base:update(dt)

end

function Base:draw()
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(1)
	love.graphics.circle("line", self.x*Scale + Scale/2, self.y*Scale + Scale/2, 0.4*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end