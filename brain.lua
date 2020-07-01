Brain = Object:extend()
require "util"

function Brain:new(parent)
	self.id = NewGuid()

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.parent = parent

	self.fatigue = 0.0
	self.hunger = 9.5

	self.memory = {}
end

function Brain:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z

	self.hunger = self.hunger + 0.01

	if self.hunger > 10 then
		table.insert(Queue, Task(self.id, "EAT"))
		for i,v in ipairs(Seeds) do
			local h_distance = v.x - self.x
			local v_distance = v.y - self.y
			local distance = math.sqrt(h_distance^2 + v_distance^2)
			if v.z == self.z and distance < 3 then
				table.insert(self.memory, v)
			end
		end
	end

	food = self.memory[0]
	if food == nil then
		return
	end

	local angle = math.atan2(food.x - self.x, food.y - self.y)
	local cos = math.cos(angle)
	local sin = math.sin(angle)

	self.x = self.x + self.speed * cos * dt
	self.y = self.y + self.speed * sin * dt
end

function Brain:draw()
	love.graphics.setColor(0.8, 0.5, 0.7, 1)
	love.graphics.ellipse("fill", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.14*Scale, 0.18*Scale)
	love.graphics.print("ID: " .. self.id, self.x*Scale + Scale, self.y*Scale + 12*-1)
	love.graphics.print("Hunger: " .. self.hunger, self.x*Scale + Scale, self.y*Scale + 12*2)
	love.graphics.print("Fatigue: " .. self.fatigue, self.x*Scale + Scale, self.y*Scale + 12*3)

	if food ~= nil then
		love.graphics.print("food: " .. food.x .. "/" .. food.y, self.x*Scale + Scale, self.y*Scale + 12*4)
	end

	local memory = ""
	for i,v in ipairs(self.memory) do
		memory = memory .. "; " .. i .. ":" .. v.x .. "/" .. v.y .. "/" .. v.z
	end
	love.graphics.print("Memory: " .. memory, self.x*Scale + Scale, self.y*Scale + 12*5)
end