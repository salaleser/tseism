Help = Object:extend()

function Help:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.visible = false
end

function Help:keypressed(key, scancode, isrepeat)
	if key == "h" then
		if self.visible then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function Help:draw()
	if not self.visible then
		return
	end

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	local lines = {}

	table.insert(lines, {"Keys:"})
	table.insert(lines, {""})
	table.insert(lines, {"a, z — change Z-level"})
	table.insert(lines, {"0, -, =, [, ] — change scale"})
	table.insert(lines, {"tab — menu"})
	table.insert(lines, {"m — minimap"})
	table.insert(lines, {"~ — console"})
	table.insert(lines, {"r — restart"})
	table.insert(lines, {"escape — quit"})
	table.insert(lines, {"h — help"})
	table.insert(lines, {"b — blocked tiles"})

	local lineHeight = 12
	for j, line in pairs(lines) do
		if line[2] ~= nil then
			love.graphics.setColor(line[2])
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
		love.graphics.print(line[1], self.x + 0.4*self.w, self.y + 0.2*self.h + (j - 1)*lineHeight)
	end
end