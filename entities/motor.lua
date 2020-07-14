Motor = Object:extend()

function Motor:new(base)
	Motor.type = "Motor"

	Motor.taskMove = 1

	self.id = base.id
	self.type = Motor.type
	self.color = Color.blue

	self.base = base
	self.x = base.x
	self.y = base.y
	self.z = base.z

	table.insert(base.parts, self)
end

function Motor:update(dt)

end

function Motor:draw()
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(3)
	love.graphics.line(
		self.x*Scale,
		self.y*Scale,
		self.x*Scale + Scale,
		self.y*Scale + Scale
	)
	love.graphics.line(
		self.x*Scale + Scale,
		self.y*Scale,
		self.x*Scale,
		self.y*Scale + Scale
	)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end