Minimap = Object:extend()

function Minimap:new()
	local x, y, w, h = love.window.getSafeArea()

	self.x = x + h
	self.y = y + 1
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

function Minimap:update()
	for i = 0, WorldSize.width do
		local row = {}
		for j = 0, WorldSize.height do
			if Pathfinder:isPassable(j, i) then
				table.insert(row, 1)
			else
				table.insert(row, 0)
			end
		end
		table.insert(self.map, row)
	end
end

function Minimap:draw()
	if not self.visible then
		return
	end

	self:drawBackground()
	self:drawBorder()
	self:drawMinimap()
end

function Minimap:drawBackground()
	love.graphics.setColor(Color.black)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Minimap:drawBorder()
	love.graphics.setColor(Color.white)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

function Minimap:drawMinimap()
	for i = 1, #self.map do
		for j = 1, #self.map[i] do
			if self.map[i][j] == 0 then
				love.graphics.setColor(Color.gray)
			elseif self.map[i][j] == 1 then
				love.graphics.setColor(Color.black)
			end
			love.graphics.rectangle("fill", j - 1 + self.x, i - 1 + self.y, 1, 1)
		end
	end
end