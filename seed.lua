Seed = Object:extend()
require "util"

function Seed:new(x, y, z)
	self.id = NewGuid()

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
	love.graphics.setColor(1, 0.78, 0.15, 1)
	love.graphics.circle("fill", self.x*Scale + Scale/4, self.y*Scale + Scale/4, Scale/8)

	self:drawStats()
end

function Seed:drawStats()
	if self.x ~= Cursor.x
	or self.y ~= Cursor.y
	or Scale < 16 then
		return
	end

	love.graphics.setColor(1, 0.78, 0.15, 0.8)
	love.graphics.print("ID: "..self.id, (self.x + 0)*Scale, (self.y + 0)*Scale - Scale/2)
end

function Seed:destroy()
	for i,v in ipairs(Seeds) do
		if self.id == v.id then
			table.remove(Seeds, i)
			return
		end
	end
end