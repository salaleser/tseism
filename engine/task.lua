Task = Object:extend()

function Task:new(contractorId, contractorType, kind, x, y, target)
	self.contractorId = contractorId
	self.contractorType = contractorType
	self.kind = kind
	self.x = x
	self.y = y
	self.target = target
end