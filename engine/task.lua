Task = Object:extend()

function Task:new(contractorId, contractorType, kind, target)
	self.contractorId = contractorId
	self.contractorType = contractorType
	self.kind = kind
	self.target = target
end