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

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(3)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

	local lines = {}

	for j, line in pairs(lines) do
		if line[2] ~= nil then
			love.graphics.setColor(line[2])
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
		-- love.graphics.print(line[1], minimap.x1 + 3, minimap.y1 + minimap.y1 + (j - 1)*lineHeight)
	end
end

function Minimap:clear()
	self.map = {}
end