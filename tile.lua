Tile = Object:extend()

function Tile:new(x, y, width, height)
	self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 100
end

function Tile:update(dt)
    self.x = self.x + self.speed * dt
end

function Tile:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end