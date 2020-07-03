Task = Object:extend()

function Task:new(contractor, category, code, x, y)
	self.contractor = contractor
	self.category = category
	self.code = code
	self.x = x
	self.y = y
end