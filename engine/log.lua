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
	self:add({"[" .. time .. " ERR] " .. text, Color.salmon})
end

function Log:warning(text)
	local time = math.ceil(love.timer.getTime() - StartTime)
	self:add({"[" .. time .. " WRN] " .. text, Color.cornflower})
end

function Log:information(text)
	local time = math.ceil(love.timer.getTime() - StartTime)
	self:add({"[" .. time .. " INF] " .. text, Color.iris})
end

function Log:debug(text)
	local time = math.ceil(love.timer.getTime() - StartTime)
	self:add({"[" .. time .. " DBG] " .. text, Color.darkGray})
end