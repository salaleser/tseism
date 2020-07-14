Manipulator = Object:extend()

function Manipulator:new(base)
	Manipulator.type = "Manipulator"

	self.id = base.id
	self.type = Manipulator.type
	self.color = Color.cyan

	self.base = base
	self.x = base.x
	self.y = base.y
	self.z = base.z

	table.insert(base.parts, self)
end

function Manipulator:update(dt)
	self.x = self.base.x
	self.y = self.base.y
	self.z = self.base.z
end

function Manipulator:draw()
	love.graphics.setColor(self.color)
	love.graphics.setLineWidth(3)
	love.graphics.line(self.x*Scale, self.y*Scale + Scale/2, self.x*Scale + Scale, self.y*Scale + Scale/2)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end