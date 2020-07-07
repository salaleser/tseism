Menu = Object:extend()

function Menu:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = h
	self.y = y
	self.w = w - h
	self.h = h
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

	love.graphics.setColor(Color.black)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	love.graphics.setColor(Color.white)
	love.graphics.setLineWidth(1)
	love.graphics.line(self.x, self.y, self.x, self.h)

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
		if v.force ~= nil then
			table.insert(lines, {"  Force: " .. v.force, v.color})
		end
		if v.speed ~= nil then
			table.insert(lines, {"  Speed: " .. v.speed, v.color})
		end
		if v.tasks ~= nil then
			local target = ""
			table.insert(lines, {"  Tasks: ", v.color})
			for i, task in ipairs(v.tasks) do
				if task.x ~= nil
				and task.y ~= nil then
					target = task.x .. "," .. task.y
				elseif task.target ~= nil then
					target = task.target.x .. "," .. task.target.y
				end
				table.insert(lines, {"    " .. i .. ". " .. v.task.contractorType .. "." .. v.task.kind .. "(" .. target .. ")", v.color})
			end
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