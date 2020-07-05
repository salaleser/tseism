Log = Object:extend()

function Log:new()
	self.list = {}
	self.limit = 8
end

function Log:update(dt)
	if #self.list > self.limit then
		table.remove(self.list, 1)
	end
end

function Log:add(line)
	for _, v in ipairs(self.list) do
		if v[1] == line[1] then
			return
		end
	end

	table.insert(self.list, line)
end

function Log:error(text)
	local time = math.ceil(love.timer.getTime() - StartTime)
	local color = {1, 0.2, 0.2, 1}
	self:add({"[" .. time .. " ERR] " .. text, color})
end

function Log:warning(text)
	local time = math.ceil(love.timer.getTime() - StartTime)
	local color = {1, 1, 0, 1}
	self:add({"[" .. time .. " WRN] " .. text, color})
end

function Log:information(text)
	local time = math.ceil(love.timer.getTime() - StartTime)
	local color = {0.2, 0.4, 1, 1}
	self:add({"[" .. time .. " INF] " .. text, color})
end

function Log:debug(text)
	local time = math.ceil(love.timer.getTime() - StartTime)
	local color = {0.5, 0.5, 0.5, 1}
	self:add({"[" .. time .. " DBG] " .. text, color})
end