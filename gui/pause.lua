Pause = Object:extend()

function Pause:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.active = false
end

function Pause:keypressed(key, scancode, isrepeat)
	if key == "space" then
		if self.active then
			self.active = false
		else
			self.active = true
		end
	end
end

function Pause:draw()
	if not self.active then
		return
	end

	love.graphics.setColor(Color.canary)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end