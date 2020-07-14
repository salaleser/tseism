Menu = Object:extend()

function Menu:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = h
	self.y = y + 1
	self.w = w - h
	self.h = h - 1
	self.visible = true
	self.list = {}
end

function Menu:keypressed(key, scancode, isrepeat)
	if key == "tab" then
		if self.visible then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function Menu:draw()
	if not self.visible then
		return
	end

	local lines = {}

	for _, v in ipairs(self.list) do
		if v.type ~= nil then
			table.insert(lines, {"[" .. v.type .. "]", v.color})
		end
		if v.x ~= nil
		and v.y ~= nil
		and v.z ~= nil then
			table.insert(lines, {"  Position: " .. v.x .. "•" .. v.y .. "•" .. v.z, v.color})
		end
		if v.id ~= nil then
			table.insert(lines, {"  ID: " .. v.id, v.color})
		end
		if v.health ~= nil then
			table.insert(lines, {"  Health: " .. v.health, v.color})
		end
		if v.fatigue ~= nil then
			table.insert(lines, {"  Fatigue: " .. v.fatigue, v.color})
		end
		if v.hunger ~= nil then
			table.insert(lines, {"  Hunger: " .. v.hunger, v.color})
		end
		if v.speed ~= nil then
			table.insert(lines, {"  Speed: " .. v.speed, v.color})
		end
		if v.tasks ~= nil then
			local tasksText = "  Tasks: "
			for i, task in ipairs(v.tasks) do
				tasksText = tasksText .. i .. "=" .. task .. "; "
			end
			table.insert(lines, {tasksText, v.color})
		end
	end

	table.insert(lines, {"[Queue]", Color.corn})
	for i, v in ipairs(Queue.queue) do
		local target = ""
		if v.x ~= nil
		and v.y ~= nil then
			target = v.x .. "," .. v.y
		elseif v.target ~= nil then
			target = v.target.x .. "," .. v.target.y
		end
		table.insert(lines, {i .. ": " .. v.contractorType .. "." .. v.kind .. "(" .. target .. ")", Color.corn})
	end

	self:drawBackground()
	self:drawBorder()
	self:drawMenu(lines)
end

function Menu:drawBackground()
	love.graphics.setColor(Color.black)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Menu:drawBorder()
	love.graphics.setColor(Color.white)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function Menu:drawMenu(lines)
	local lineHeight = 12
	for j, line in pairs(lines) do
		if line[2] ~= nil then
			love.graphics.setColor(line[2])
		else
			love.graphics.setColor(Color.white)
		end
		local yOffset = 0
		if Minimap.visible then
			yOffset = Minimap.h
		end
		love.graphics.print(line[1], self.x + 3, self.y + yOffset + (j - 1)*lineHeight)
	end
end

function Menu:append(o)
	for _, v in pairs(self.list) do
		if v == o then
			return
		end
	end

	table.insert(self.list, o)
end

function Menu:clear()
	self.list = {}
end