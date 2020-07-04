Brain = Object:extend()
local pajarito = require 'pajarito'
require "util"

function Brain:new(base, parent)
	self.id = base.id

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.base = base
	self.parent = parent
	self.task = nil

	self.path = {}

	self.fatigue = 0.0
	self.hunger = 8.0

	self.memory = {}
end

function Brain:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z

	self.hunger = self.hunger + 2 * dt

	if self.hunger > 10 then
		local task = Task(self.id, "INTEL", "EAT", nil, nil)
		if Contains(Queue, task) == false then
			table.insert(Queue, task)
		end
	end

	self:manage()

	if self.task ~= nil then
		self:act()
	end
end

function Brain:draw()

	-- draw brain
	local color = { 0.8, 0.5, 0.7, 0.5 }
	if self.task ~= nil then
		color = { 0.8, 0.5, 0.7, 1 }
	end
	love.graphics.setColor(color)
	love.graphics.ellipse("fill", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.14*Scale, 0.18*Scale)

	self:drawStats()
end

function Brain:drawStats()
	if self.x ~= Cursor.x
	or self.y ~= Cursor.y
	or Scale < 16 then
		-- return -1
	end

	love.graphics.setColor(0.8, 0.5, 0.7, 1)

	love.graphics.print("Hunger: "..self.hunger, self.x*Scale + Scale, self.y*Scale + 12*5)

	local memory = "Memory: "
	for i,v in ipairs(self.memory) do
		memory = memory..i..":"..v.x.."/"..v.y.."/".. v.z
	end
	love.graphics.print(memory, self.x*Scale + Scale, self.y*Scale + 12*6)
	if self.task ~= nil then
		love.graphics.print("Task: "..self.task.category..":"..self.task.code, self.x*Scale + Scale, self.y*Scale + 12*7)
	end
	if self.path ~= nil then
		love.graphics.print("Path: "..#self.path, self.x*Scale + Scale, self.y*Scale + 12*8)
	end
end

function Brain:manage()
	for i,v in ipairs(Queue) do
		if v.contractor == self.id
		and v.category == "INTEL" then
			self.task = v
			table.remove(Queue, i)
		end
	end
end

function Brain:act()
	self:scan()

	-- move
	if #self.memory > 0 then
		local food = self.memory[1]
		self.path = pajarito.pathfinder(self.x, self.y, food.x, food.y)
		if #self.path > 1 then
			local task = Task(self.id, "MOTOR", "MOVE", self.path[2].x, self.path[2].y)
			if Contains(Queue, task) == false then
				table.insert(Queue, task)
			end
		end
	end
end

function Brain:scan()
	local map = {}
	local viewDistanceX1 = self.x - 16
	local viewDistanceY1 = self.y - 16
	local viewDistanceX2 = self.x + 16
	local viewDistanceY2 = self.y + 16
	for i=viewDistanceX1,viewDistanceX2 do
		for j=viewDistanceY1,viewDistanceY2 do
			for _,v in ipairs(Blocks) do
				if v.x == j and v.y == i then
					table.insert(map, 0)
				else
					table.insert(map, 1)
				end
			end
		end
	end
	pajarito.init(map, WorldSize.width, WorldSize.height, true)
	for _,v in ipairs(Seeds) do
		local h_distance = v.x - self.x
		local v_distance = v.y - self.y
		local distance = math.sqrt(h_distance^2 + v_distance^2)
		if v.z == self.z and distance < 9 then
			if Contains(self.memory, v) == false then
				table.insert(self.memory, v)
			end
		end
	end
end