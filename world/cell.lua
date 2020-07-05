Cell = Object:extend()

function Cell:new(x, y, z)
	self.type = "Cell"
	self.color = {0.4, 0.4, 0.4, 1}

	self.x = x
	self.y = y
	self.z = z
end

function Cell:update(dt)

end

function Cell:draw()
	if Scale > 12 then
		love.graphics.setColor(self.color)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", self.x*Scale, self.y*Scale, Scale, Scale)
	end

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end