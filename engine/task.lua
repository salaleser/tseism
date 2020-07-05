Task = Object:extend()

function Task:new(contractor, category, code, x, y, target)
	self.contractor = contractor
	self.category = category
	self.code = code
	self.x = x
	self.y = y
	self.target = target
end