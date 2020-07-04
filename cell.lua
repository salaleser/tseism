Cell = Object:extend()

function Cell:new(x, y, z)
	self.x = x
	self.y = y
	self.z = z
end

function Cell:update(dt)

end

function Cell:draw()
	if Scale > 12 then
		love.graphics.setColor(1, 1, 1, 0.4)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", self.x*Scale, self.y*Scale, Scale, Scale)
	end

	self:drawStats()
end

function Cell:drawStats()
	if self.x ~= Cursor.x
	or self.y ~= Cursor.y
	or Scale < 16 then
		return -1
	end

	love.graphics.setColor(1, 1, 1, 0.6)
	love.graphics.print(self.z, self.x*Scale, self.y*Scale)
end