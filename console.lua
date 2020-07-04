Console = Object:extend()

function Console:new()
	self.visible = true
end

function Console:keypressed(key, scancode, isrepeat)
	if key == "`" then
		if self.visible then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function Console:draw()
	if not self.visible then
		return
	end

	local lineHeight = 12
	local x, y, w, h = love.window.getSafeArea()
	local menu = {
		x1 = 4,
		y1 = h - lineHeight*#Log.list,
		x2 = w - 8,
		y2 = h - 4
	}

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("fill", menu.x1, menu.y1, menu.x2, menu.y2)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", menu.x1, menu.y1, menu.x2, menu.y2)

	love.graphics.setColor(1, 1, 1, 1)
	for i, v in ipairs(Log.list) do
		love.graphics.print(v, menu.x1 + 2, menu.y1 + lineHeight*(#Log.list - i))
	end
end