Cell = Object:extend()

function Cell:new(x, y, z)
	self.x = x
	self.y = y
	self.z = z
end

function Cell:update(dt)

end

function Cell:draw()
	love.graphics.setColor(1, 1, 1, 0.4)
	love.graphics.rectangle("line", self.x*Scale, self.y*Scale, Scale, Scale)

	love.graphics.setColor(1, 1, 1, 0.2)
	love.graphics.print(self.z, self.x*Scale, self.y*Scale)
end