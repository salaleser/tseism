Cursor = Object:extend()

function Cursor:new(x, y)
	self.x = x
	self.y = y
end

function Cursor:update(dt)
	local mouse_x, mouse_y = love.mouse.getPosition()
	local x = math.ceil(mouse_x/Scale) - 1
	local y = math.ceil(mouse_y/Scale) - 1
	if x ~= self.x or y ~= self.y then
		self.x = math.ceil(mouse_x/Scale) - 1
		self.y = math.ceil(mouse_y/Scale) - 1
	end
end

function Cursor:keypressed(key, scancode, isrepeat)
	if key == "up" then
		if self.y > 0 then
			self.y = self.y - 1
		end
	elseif key == "down" then
		if self.y < WorldSize.width then
			self.y = self.y + 1
		end
	end

	if key == "left" then
		if self.x > 0 then
			self.x = self.x - 1
		end
	elseif key == "right" then
		if self.x < WorldSize.width then
			self.x = self.x + 1
		end
	end
end

function Cursor:draw()
	love.graphics.setColor(1, 0, 0, 0.8)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", self.x*Scale, self.y*Scale, Scale, Scale)

	self:drawStats()
end

function Cursor:drawStats()
	if Scale < 16 then
		return
	end

	love.graphics.setColor(1, 0, 0, 0.8)
	love.graphics.print(self.x.."•"..self.y, (self.x + 0)*Scale, (self.y + 1)*Scale)
end
