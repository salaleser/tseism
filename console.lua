Console = Object:extend()
require "util"

function Console:new()
	self.visible = false
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

	local list = {}
	table.insert(list, "Level: "..Level)
	table.insert(list, "Scale: "..Scale)
	table.insert(list, "FPS: "..love.timer.getFPS())
	table.insert(list, "Keys: a z — level, 0 - = — scale, [ ] — scale")
	local queue = "Queue: "
	for i,v in ipairs(Queue) do
		queue = queue..i.."."..v.category..":"..v.code
		if v.x ~= nil and v.y ~= nil then
			queue = queue..", "..v.x.."/"..v.y.." "
		end
	end
	table.insert(list, queue)

	local lineHeight = 12
	local x, y, w, h = love.window.getSafeArea()
	local menu = {
		x1 = 4,
		y1 = h - lineHeight*#list,
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
	for i,v in ipairs(list) do
		love.graphics.print(v, menu.x1 + 2, menu.y1 + lineHeight*(#list - i))
	end
end