Brain = Object:extend()
require "util"

function Brain:new(parent)
	self.id = parent.id

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.parent = parent
	self.task = nil

	self.fatigue = 0.0
	self.hunger = 9.0

	self.memory = {}
end

function Brain:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z

	self.hunger = self.hunger + 0.02

	if self.hunger > 10 then
		local task = Task(self.id, "EAT")
		if Contains(Queue, task) == false then
			table.insert(Queue, task)
		end
	end

	self:manage()

	for _,v in ipairs(Seeds) do
		local h_distance = v.x - self.x
		local v_distance = v.y - self.y
		local distance = math.sqrt(h_distance^2 + v_distance^2)
		if v.z == self.z and distance < 5 then
			if Contains(self.memory, v) == false then
				table.insert(self.memory, v)
			end
		end
	end

	food = self.memory[1]
	if food ~= nil then
		table.insert(Queue, Task(self.id, "MOVE", food))
	end
end

function Brain:draw()
	local color = { 0.8, 0.5, 0.7, 0.5 }
	if self.task ~= nil then
		color = { 0.8, 0.5, 0.7, 1 }
	end

	love.graphics.setColor(color)
	love.graphics.ellipse("fill", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.14*Scale, 0.18*Scale)
	love.graphics.print("ID: " .. self.id, self.x*Scale + Scale, self.y*Scale + 12*-1)
	love.graphics.print("Hunger: " .. self.hunger, self.x*Scale + Scale, self.y*Scale + 12*2)
	love.graphics.print("Fatigue: " .. self.fatigue, self.x*Scale + Scale, self.y*Scale + 12*3)

	if food ~= nil then
		love.graphics.print("food: " .. food.x .. "/" .. food.y, self.x*Scale + Scale, self.y*Scale + 12*4)
	end

	local memory = ""
	for i,v in ipairs(self.memory) do
		memory = memory .. "\n" .. i .. ":" .. v.x .. "/" .. v.y .. "/" .. v.z
	end
	love.graphics.print("Memory: " .. memory, self.x*Scale + Scale, self.y*Scale + 12*5)
end

function Brain.manage(self)
	for i,v in ipairs(Queue) do
		if v.contractor == self.id then
			self.task = v
			table.remove(Queue, i)
		end
	end
end