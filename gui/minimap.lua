Minimap = Object:extend()

function Minimap:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = x + h
	self.y = y
	self.w = w - h
	self.h = w - h
	self.visible = true
	self.map = {}
end

function Minimap:keypressed(key, scancode, isrepeat)
	if key == "m" then
		if self.visible then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function Minimap:draw()
	if not self.visible then
		return
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	local blocked = {0.8, 0.8, 0.8, 1}
	local passable = {0, 0, 0, 1}
	for i = 1, WorldSize.width do
		for j = 1, WorldSize.height do
			if self.map[i][j] == 0 then
				love.graphics.setColor(blocked)
			elseif self.map[i][j] == 1 then
				love.graphics.setColor(passable)
			end
			love.graphics.rectangle("fill", j - 1 + self.x, i - 1 + self.y, 1, 1)
		end
	end
end