Menu = Object:extend()

function Menu:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = h
	self.y = y
	self.w = w - h
	self.h = h
	self.visible = true
	self.helpVisible = false
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

	if key == "h" then
		if self.helpVisible then
			self.helpVisible = false
		else
			self.helpVisible = true
		end
	end
end

function Menu:draw()
	if not self.visible then
		return
	end

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(3)
	love.graphics.line(self.x, self.y, self.x, self.h)

	local lines = {}

	table.insert(lines, {"[Status]"})
	local fps = love.timer.getFPS()
	local fpsColor = {0, 1, 0, 1}
	if fps < 60
	and fps > 55 then
		fpsColor = {1, 1, 0, 1}
	else
		fpsColor = {1, 0, 0, 1}
	end
	table.insert(lines, {" FPS: "..love.timer.getFPS(), fpsColor})
	table.insert(lines, {" Pointer: "..Cursor.x.."•"..Cursor.y})
	table.insert(lines, {" Level: "..Level})
	table.insert(lines, {" Scale: "..Scale})
	table.insert(lines, {""})

	for i, v in ipairs(self.list) do
		if v.type ~= nil then
			table.insert(lines, {"["..v.type.."]", v.color})
		end
		if v.x ~= nil
		and v.y ~= nil
		and v.z ~= nil
		and i == 1 then
			table.insert(lines, {" Position: "..v.x.."•"..v.y.."•"..v.z, v.color})
		end
		if v.id ~= nil then
			table.insert(lines, {" ID: "..v.id, v.color})
		end
		if v.health ~= nil then
			table.insert(lines, {" Health: "..v.health, v.color})
		end
		if v.fatigue ~= nil then
			table.insert(lines, {" Fatigue: "..v.fatigue, v.color})
		end
		if v.hunger ~= nil then
			table.insert(lines, {" Hunger: "..v.hunger, v.color})
		end
		if v.force ~= nil then
			table.insert(lines, {" Force: "..v.force, v.color})
		end
		if v.speed ~= nil then
			table.insert(lines, {" Speed: "..v.speed, v.color})
		end
		if v.task ~= nil then
			local target = ""
			if v.task.x ~= nil
			and v.task.y ~= nil then
				target = v.task.x..","..v.task.y
			elseif v.task.target ~= nil then
				target = v.task.target.x..","..v.task.target.y
			end
			table.insert(lines, {" Task: "..v.task.category.."."..v.task.code.."("..target..")", v.color})
		end
		table.insert(lines, {""})
	end

	local queueColor = {1, 1, 0, 1}
	table.insert(lines, {"[Queue]", queueColor})
	for i, v in ipairs(Queue) do
		local target = ""
		if v.x ~= nil
		and v.y ~= nil then
			target = v.x..","..v.y
		elseif v.target ~= nil then
			target = v.target.x..","..v.target.y
		end
		table.insert(lines, {i..": "..v.category.."."..v.code.."("..target..")", queueColor})
	end
	table.insert(lines, {""})

	if self.helpVisible then
		table.insert(lines, {"[Help]"})
		table.insert(lines, {" Keys:"})
		table.insert(lines, {"  [a], [z] — change Z-level"})
		table.insert(lines, {"  [0], [-], [=] — change scale"})
		table.insert(lines, {"  [tab] — menu"})
		table.insert(lines, {"  [m] — minimap"})
		table.insert(lines, {"  [~] — console"})
	else
		table.insert(lines, {"[Help]... (press H to expand)"})
	end
	table.insert(lines, {""})

	local lineHeight = 12
	for j, line in pairs(lines) do
		if line[2] ~= nil then
			love.graphics.setColor(line[2])
		else
			love.graphics.setColor(1, 1, 1, 1)
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