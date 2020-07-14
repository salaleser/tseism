Head = Object:extend()

function Head:new(base)
	Head.type = "Head"

	self.id = base.id
	self.type = Head.type
	self.color = Color.white

	self.base = base
	self.x = base.x
	self.y = base.y
	self.z = base.z

	table.insert(base.parts, self)
end

function Head:update(dt)

end

function Head:draw()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.ellipse("line", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.2*Scale, 0.22*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end