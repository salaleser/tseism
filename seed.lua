Seed = Object:extend()

function Seed:new(x, y, z)
	self.id = NewGuid()
	self.type = "Seed"
	self.color = { 1, 0.78, 0.15, 1 }

	self.x = x
	self.y = y
	self.z = z

	self.health = 100.0
end

function Seed:update(dt)
	if self.health <= 0 then
		self:destroy()
	end
end

function Seed:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.x*Scale + Scale/4, self.y*Scale + Scale/4, Scale/8)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
		Menu:append(self)
	end
end

function Seed:destroy()
	for i, v in ipairs(Seeds) do
		if self.id == v.id then
			table.remove(Seeds, i)
			return
		end
	end
end