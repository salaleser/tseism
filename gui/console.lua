Console = Object:extend()

function Console:new()
	local x, y, w, h = love.window.getSafeArea()

	self.lineHeight = 12

	self.x = 8
	self.y = h - self.lineHeight*Log.limit
	self.w = w - 16
	self.h = Log.limit*self.lineHeight + 4
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

	love.graphics.setColor(0, 0, 0, 0.8)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	love.graphics.setColor(Color.white)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	for i, line in ipairs(Log.list) do
		if line[2] == nil then
			love.graphics.setColor(Color.white)
		else
			love.graphics.setColor(line[2])
		end
		love.graphics.print(line[1], self.x + 3, self.y + self.lineHeight*(Log.limit - i))
	end
end