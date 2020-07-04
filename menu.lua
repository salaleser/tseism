Menu = Object:extend()
require "util"

function Menu:new()
	self.visible = true
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

	local list = {}

	local lineHeight = 12
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

	love.graphics.setColor(1, 1, 1, 1)
	for i,v in ipairs(list) do
		love.graphics.print(v, menu.x1 + 2, menu.y1 + lineHeight*(#list - i))
	end
end