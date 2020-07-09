Pathfinder = Object:extend()

function Pathfinder:new()
	self.map = {}
	self.visible = false
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

function Pathfinder:find(x1, y1, x2, y2)
	local queue = {{x = x2, y = y2, c = 0}}

	for c, element in ipairs(queue) do
		local cells = {}

		table.insert(cells, {x = element.x + 0, y = element.y - 1, c = c})
		table.insert(cells, {x = element.x + 1, y = element.y + 0, c = c})
		table.insert(cells, {x = element.x + 0, y = element.y + 1, c = c})
		table.insert(cells, {x = element.x - 1, y = element.y + 0, c = c})

		-- If the cell is a wall, remove it from the list
		for cellNumber, cell in ipairs(cells) do
			if not self:isPassable(cell.x, cell.y) then
				table.remove(cells, cellNumber)
			end
		end

		-- If there is an element in the main list with the same coordinate and a
		-- less than or equal counter, remove it from the cells list
		for _, node in ipairs(queue) do
			for cellNumber, cell in ipairs(cells) do
				if node.x == cell.x
				and node.y == cell.y
				and node.c <= cell.c then
					table.remove(cells, cellNumber)
				end
			end
		end

		-- Add all remaining cells in the list to the end of the main list
		for _, cell in ipairs(cells) do
			table.insert(queue, cell)
		end

		-- Check wether start coordinates is the same as destination
		for _, node in ipairs(queue) do
			if node.x == x1
			and node.y == y1 then
				return queue
			end
		end
	end
end