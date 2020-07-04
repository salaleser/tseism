Menu = Object:extend()

function Menu:new()
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

	local x, y, w, h = love.window.getSafeArea()
	local menu = {
		x1 = h,
		y1 = 0,
		x2 = w,
		y2 = h
	}

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", menu.x1, menu.y1, menu.x2, menu.y2)

	love.graphics.setColor(1, 1, 1, 0.8)
	love.graphics.setLineWidth(3)
	love.graphics.line(menu.x1, menu.y1, menu.x1, menu.y2)

	local lineHeight = 12
	local lines = {}
	for _, v in pairs(self.list) do
		if v.type ~= nil then
			table.insert(lines, {"["..v.type.."]", v.color})
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

	table.insert(lines, {"[Help]"})
	table.insert(lines, {" Keys:"})
	table.insert(lines, {"  [a], [z] — change Z-level"})
	table.insert(lines, {"  [0], [-], [=] — change scale"})
	table.insert(lines, {"  [[], []] — change scale"})

	for j, line in pairs(lines) do
		if line[2] ~= nil then
			love.graphics.setColor(line[2])
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
		love.graphics.print(line[1], menu.x1 + 4, menu.y1 + j*lineHeight)
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