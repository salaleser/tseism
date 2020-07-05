Queue = Object:extend()

function Queue:new()
	self.queue = {}
end

function Queue:add(task)
	if not Contains(Queue, task) then
		table.insert(Queue, task)
	end
end