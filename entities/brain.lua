Brain = Object:extend()

function Brain:new(base, parent)
	self.id = base.id
	self.type = "Brain"
	self.color = { 0.8, 0.5, 0.7, 1 }

	self.x = parent.x
	self.y = parent.y
	self.z = parent.z

	self.base = base
	self.parent = parent
	self.tasks = {}
	self.path = {}
	self.eatables = {}
	self.fovLimit = 10

	self.hunger = 8
end

function Brain:update(dt)
	self.x = self.parent.x
	self.y = self.parent.y
	self.z = self.parent.z

	self.hunger = self.hunger + 2 * dt

	if self.hunger > 10 then
		Queue:add(Task(self.id, "INTEL", "GET_FOOD", nil, nil))
	end

	self:takeTask()

	local err = self:processTask()
	if err then
		Log:append("ERROR: " .. self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. err)
	end
end

function Brain:draw()
	local color = {0.8, 0.5, 0.7, 0.5}
	if #self.tasks > 0 then
		color = self.color
	end
	love.graphics.setColor(color)
	love.graphics.setLineWidth(1)
	love.graphics.ellipse("fill", self.x*Scale + Scale/2, self.y*Scale + 0.25*Scale, 0.14*Scale, 0.18*Scale)

	if Cursor.selectedX == self.x
	and Cursor.selectedY == self.y
	and Cursor.selectedZ == self.z then
	end
	Menu:append(self) -->FIXME

	self:drawTarget()
	self:drawPath()
	self:drawFov()
end

function Brain:drawTarget()
	if self.task == nil
	or self.task.target == nil then
		return
	end

	love.graphics.setColor(1, 0.5, 0.5, 0.5)
	love.graphics.setLineWidth(1)
	love.graphics.circle("line", self.task.target.x*Scale + Scale/2, self.task.target.y*Scale + Scale/2, 0.4*Scale)
end

function Brain:drawPath()
	if self.path == nil
	or #self.path < 2 then
		return
	end

	love.graphics.setColor(0.5, 1, 0.5, 0.5)
	local x = self.path[#self.path].x*Scale + Scale/2
	local y = self.path[#self.path].y*Scale + Scale/2
	love.graphics.circle("line", x, y, Scale/2)

	for i = 2, #self.path do
		local x1 = self.path[i-1].x*Scale + Scale/2
		local y1 = self.path[i-1].y*Scale + Scale/2
		local x2 = self.path[i].x*Scale + Scale/2
		local y2 = self.path[i].y*Scale + Scale/2
		love.graphics.line(x1, y1, x2, y2)
	end
end

function Brain:drawFov()
	if self.x ~= Cursor.selectedX
	or self.y ~= Cursor.selectedY
	or Scale < 16 then
		return
	end

	love.graphics.setColor(0, 1, 0, 0.15)
	local r = self.fovLimit
	for i = self.x - r, self.x + r do
		for j = self.y - r, self.y + r do
			love.graphics.rectangle("fill", i*Scale, j*Scale, Scale, Scale)
		end
	end
end

function Brain:takeTask()
	for i,v in ipairs(Queue) do
		if v.contractor == self.id
		and v.category == "INTEL" then
			table.insert(self.tasks, table.remove(Queue, i))
			Log:append("INFO: " .. self.type .. " (" .. self.x .. "•" .. self.y .. "•" .. self.z .. ", " .. self.id .. "): " .. "got a task \"" .. v.code .. "\"")
		end
	end
end

function Brain:processTask()
	if #self.tasks == 0 then
		return
	end

	local task = table.remove(self.tasks)

	if task.code == "GET_FOOD" then
		if #self.eatables == 0 then
			self.eatables = self:findFood()
			if #self.eatables == 0 then
				return "there is no food"
			end
		end

		local target = self.eatables[1]

		-- make orders
		if self.x == target.x
		and self.y == target.y
		and self.z == target.z then
			-- eat food at self position
			Queue:add(Task(self.id, "HEAD", "EAT", nil, nil, target))
		else
			-- move at food position
			self.path = Pathfinder:build(self.x, self.y, target.x, target.y)
			if #self.path > 1 then
				Queue:add(Task(self.id, "MOTOR", "MOVE", self.path[2].x, self.path[2].y, nil))
			else
				return "cannot find passable route for {" .. target.x .. "," .. target.y .. "," .. target.z .. "}"
			end
		end
	elseif task.code == "SATIATE" then
		self.hunger = self.hunger - 20
		Log:append("[INFO] " .. self.type .. " says: \"Hunger reduced for 20\"")
	else
		return "cannot hanlde a task \"" .. task.code .. "\""
	end
end

-- try to find an eatable entity
function Brain:findFood()
	local food = {}

	local r = self.fovLimit
	for i = self.x - r, self.x + r do
		for j = self.y - r, self.y + r do
			for _, v in pairs(Seeds) do
				if v.x == i
				and v.y == j
				and v.z == self.z then
					table.insert(food, v)
				end
			end
		end
	end

	return food
end