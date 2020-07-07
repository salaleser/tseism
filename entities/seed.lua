Seed = Object:extend()

function Seed:new(x, y, z)
	Seed.type = "Seed"

	self.id = NewGuid()
	self.type = Seed.type
	self.color = Color.corn

	self.x = x
	self.y = y
	self.z = z

	self.health = 100
	self.lastHealth = self.health
end

function Seed:update(dt)
	if self.health <= 0 then
		self:say("I'm dead!")
		self:destroy()
	end

	if self.health ~= self.lastHealth then
		self:say("Health changed for " .. (self.health - self.lastHealth))
		self.lastHealth = self.health
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

function Seed:say(message)
	Log:information(self.type .. " says: \"" .. message .. "\"")

	-- love.graphics.setColor(self.color)
	-- love.graphics.setLineWidth(1)
	-- love.graphics.rectangle("line", (self.x + 1)*Scale, (self.y)*Scale, 64, 16)
end

function Seed:destroy()
	for i, v in ipairs(Seeds) do
		if self.id == v.id then
			table.remove(Seeds, i)
			return
		end
	end
end