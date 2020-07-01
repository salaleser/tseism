Task = Object:extend()

function Task:new(contractor, code, type)
	self.contractor = contractor
	self.code = code
	self.type = type
end

function Task:update(dt)

end

function Task:draw()
	love.graphics.setColor(1, 0, 0, 0.2)
	love.graphics.rectangle("fill", 0, 0, 10*#Queue, 10)
end