Task = Object:extend()

function Task:new(contractor, code, entity)
	self.contractor = contractor
	self.code = code
	self.entity = entity
end

function Task:update(dt)

end

function Task:draw()
	love.graphics.setColor(1, 1, 0, 0.8)

	local queue = ""
	for i,v in ipairs(Queue) do
		queue = queue .. "\n" .. i .. ":" .. v.contractor  .. ", " .. v.code
	end
	love.graphics.print("Queue: " .. queue, WorldSize.width*Scale/2, WorldSize.height*Scale + Scale)
end