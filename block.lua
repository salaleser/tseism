Block = Object:extend()
require "util"

function Block:new(x, y, z, type)
	self.id = NewGuid()

	self.x = x
	self.y = y
	self.z = z

	self.type = type
end

function Block:update(dt)

end

function Block:draw()
	love.graphics.setColor(0.2, 0.8, 0.2, 1)
	love.graphics.draw(self.tileset, self.quads[self.type], self.x*Scale, self.y*Scale, 0, Scale/32, Scale/32)

	if self.x == Cursor.x
	and self.y == Cursor.y
	and Scale > 16 then
		love.graphics.print("ID: "..self.id, self.x*Scale + Scale, self.y*Scale)
	end
end

function Block:init()
	self.tileset = love.graphics.newImage("images/tileset.png")
	self.quads = {}
	local iw = self.tileset:getWidth()
	local ih = self.tileset:getHeight()
	local w = (iw / 3) - 2
	local h = (ih / 4) - 2
	for i=0,3 do
		for j=0,2 do
			local x = 1 + j * (w + 2)
			local y = 1 + i * (h + 2)
			local quad = love.graphics.newQuad(x, y, w, h, iw, ih)
			table.insert(self.quads, quad)
		end
	end
end