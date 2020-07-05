Overlay = Object:extend()

function Overlay:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = x + 6
	self.y = y + 2
	self.visible = true
end

function Overlay:keypressed(key, scancode, isrepeat)
	if key == "f" then
		if self.visible then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function Overlay:draw()
	if not self.visible then
		return
	end

	local text = ""

	text = text .. "FPS=" .. love.timer.getFPS()
	text = text .. "  Pointer=" .. Cursor.x .. "•" .. Cursor.y
	text = text .. "  Level=" .. Level
	text = text .. "  Scale=" .. Scale

	love.graphics.setColor(1, 1, 1, 0.7)
	love.graphics.print(text, self.x, self.y)
end