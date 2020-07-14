Brain = Object:extend()

function Brain:new(base)
	Brain.type = "Brain"

	self.id = base.id
	self.type = Brain.type
	self.color = Color.cherry

	self.base = base
	self.x = base.x
	self.y = base.y
	self.z = base.z

	table.insert(base.parts, self)
end

function Brain:update(dt)

end

function Brain:draw()
	local color = {0.8, 0.5, 0.7, 0.5}
	if #self.base.tasks > 0 then
		color = self.color
	end
	love.graphics.setColor(color)
	love.graphics.setLineWidth(1)
	love.graphics.ellipse("fill", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.14*Scale, 0.18*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end