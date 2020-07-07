Queue = Object:extend()

function Queue:new()
	self.queue = {}
end

function Queue:add(task)
	for _, v in ipairs(self.queue) do
		if v.kind == task.kind
		and v.contractorType == task.contractorType
		and v.contractorId == task.contractorId then
			return
		end
	end
	table.insert(self.queue, task)
end