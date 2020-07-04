Log = Object:extend()

function Log:new()
	self.list = {}
end

function Log:update(dt)
	if #self.list > 8 then
		table.remove(self.list, 1)
	end
end

function Log:append(line)
	for i, v in ipairs(self.list) do
		if v == line then
			return
		end
	end

	table.insert(self.list, line)
end