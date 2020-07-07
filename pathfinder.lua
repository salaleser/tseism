Pathfinder = Object:extend()
local pajarito = require "libs/pajarito"

function Pathfinder:new(w, h)
	self.map = {}
	self.visible = false

	for i = 0, w do
		local row = {}
		for j = 0, h do
			if self:isPassable(j, i) then
				table.insert(row, 1)
			else
				table.insert(row, 0)
			end
		end
		table.insert(self.map, row)
	end

	pajarito.init(self.map, w, h, true)

	Minimap.map = self.map
end

function Pathfinder:build(x1, y1, x2, y2, distance)
	pajarito.buildRange(x1, y1, distance)
	pajarito.buildInRangePathTo(x2, y2)
	return pajarito.getFoundPath()
end

function Pathfinder:isPassable(x, y)
	for _, v in pairs(Blocks) do
		if v.x == x
		and v.y == y then
			if v.kind == 7
			or v.kind == 8
			or v.kind == 9 then
				return true
			end
			return false
		end
	end

	return true
end

function Pathfinder:keypressed(key, scancode, isrepeat)
	if key == "b" then
		if self.visible then
			self.visible = false
		else
			self.visible = true
		end
	end
end

function Pathfinder:draw()
	if not self.visible then
		return
	end

	for i = 1, WorldSize.width do
		for j = 1, WorldSize.height do
			if self.map[i][j] == 0 then
				love.graphics.setColor({1, 0, 0, 0.4})
			elseif self.map[i][j] == 1 then
				love.graphics.setColor({0, 1, 0, 0.4})
			end
			love.graphics.rectangle("fill", (j - 1)*Scale, (i - 1)*Scale, Scale, Scale)
		end
	end
end