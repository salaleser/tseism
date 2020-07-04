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
		-- if self.x > 0 and self.x < WorldSize.width then
			self.x = math.ceil(mouse_x/Scale) - 1
		-- end
		-- if self.y > 0 and self.y < WorldSize.height then
			self.y = math.ceil(mouse_y/Scale) - 1
		-- end
	end

	if love.keyboard.isDown("up") then
		if self.y > 0 then
			self.y = self.y - 1
		end
	elseif love.keyboard.isDown("down") then
		if self.y < WorldSize.width then
			self.y = self.y + 1
		end
	end

	if love.keyboard.isDown("left") then
		if self.x > 0 then
			self.x = self.x - 1
		end
	elseif love.keyboard.isDown("right") then
		if self.x < WorldSize.width then
			self.x = self.x + 1
		end
	end
end

function Cursor:draw()
	love.graphics.setColor(1, 0, 0, 0.8)
	love.graphics.rectangle("line", self.x*Scale, self.y*Scale, Scale, Scale)

	if self.x == Cursor.x
	and self.y == Cursor.y
	and Scale > 16 then
		love.graphics.setColor(1, 0, 0, 0.6)
		love.graphics.print(self.x.."/"..self.y, (self.x + 1)*Scale, self.y*Scale)
	end
end
