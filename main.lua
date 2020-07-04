function love.load()
	Object = require "classic"
	require "task"

	-- GUI
	require "cursor"

	-- World
	require "cell"

	-- Items
	require "seed"

	-- Ships
	require "block"
	require "ships"

	-- Creatures
	require "base"
	require "head"
	require "manipulator"
	require "brain"
	require "motor"

	love.graphics.setLineStyle("rough")
	local font = love.graphics.newFont("18432.ttf", 16)
	love.graphics.setFont(font)

	StartTime = love.timer.getTime()

	Menu = true
	Queue = {}

	Scale = 32
	ScaleLimit = 4096
	WorldSize = {
		width = 128,
		height = 128,
		depth = 8
	}

	Cursor = Cursor(WorldSize.width/2, WorldSize.height/2)
	Level = WorldSize.depth/2

	Cells = {}
	for i=0,WorldSize.width do
		for j=0,WorldSize.height do
			for k=0,WorldSize.depth do
				table.insert(Cells, Cell(j, i, k))
			end
		end
	end

	Block:init()

	Blocks = {}
	for i,row in ipairs(Ship1) do
		for j,type in ipairs(row) do
			if type ~= 0 then
				table.insert(Blocks, Block(j, i, 4, type))
			end
		end
	end

	Seeds = {}
	for i=0,WorldSize.width do
		for j=0,WorldSize.height do
			for k=0,WorldSize.depth do
				if love.math.random() > 0.98 then
					table.insert(Seeds, Seed(j, i, k))
				end
			end
		end
	end

	-- build Entities
	Entities = {}

	local base = Base(12, 12, 4)
	table.insert(Entities, base)

	local motor = Motor(base)
	table.insert(Entities, motor)

	local head = Head(base)
	table.insert(Entities, head)

	local manipulator = Manipulator(base)
	table.insert(Entities, manipulator)

	local brain = Brain(base, head)
	table.insert(Entities, brain)
end

function love.update(dt)
	for _,v in ipairs(Cells) do
		v:update(dt)
	end

	for _,v in ipairs(Blocks) do
		v:update(dt)
	end

	for _,v in ipairs(Seeds) do
		v:update(dt)
	end

	for _,v in ipairs(Entities) do
		v:update(dt)
	end

	Cursor:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
	if key == "z" then
		if Level > 0 then
			Level = Level - 1
		end
	elseif key == "a" then
		if Level < WorldSize.depth then
			Level = Level + 1
		end
	end

	if key == "-" then
		if Scale > 1 then
			Scale = Scale / 2
		end
	elseif key == "=" then
		if Scale <= ScaleLimit then
			Scale = Scale * 2
		end
	elseif key == "0" then
		Scale = 32
	end

	if key == "[" then
		if Scale > 2 then
			Scale = Scale - 1
		end
	elseif key == "]" then
		if Scale < ScaleLimit then
			Scale = Scale + 1
		end
	end

	if key == "i" then
		if Menu then
			Menu = false
		else
			Menu = true
		end
	end
end

function love.draw()
	for _,v in ipairs(Cells) do
		if v.z == Level then
			v:draw()
		end
	end

	for _,v in ipairs(Blocks) do
		if v.z == Level then
			v:draw()
		end
	end

	for _,v in ipairs(Seeds) do
		if v.z == Level then
			v:draw()
		end
	end

	for _,v in ipairs(Entities) do
		if v.z == Level then
			v:draw()
		end
	end

	-- GUI --
	Cursor:draw()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", 0, 0, (WorldSize.width + 1)*Scale, (WorldSize.height + 1)*Scale)

	-- MENU --
	if Menu then
		local info = {}
		table.insert(info, "Level: "..Level)
		table.insert(info, "Scale: "..Scale)
		table.insert(info, "Keys: a z — level, 0 - = — scale, [ ] — scale")
		local queue = "Queue: "
		for i,v in ipairs(Queue) do
			queue = queue..i.."."..v.category..":"..v.code
			if v.x ~= nil and v.y ~= nil then
				queue = queue..", "..v.x.."/"..v.y.." "
			end
		end
		table.insert(info, queue)
		DrawMenu(info)
	end
end

function DrawMenu(list)
	local lineHeight = 12
	local x, y, w, h = love.window.getSafeArea()
	local menu = {
		x = 4,
		y = h - lineHeight*#list,
		w = w - 8,
		h = h - 4
	}

	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", menu.x, menu.y, menu.w, menu.h)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", menu.x, menu.y, menu.w, menu.h)

	love.graphics.setColor(1, 1, 1, 1)
	for i,v in ipairs(list) do
		love.graphics.print(v, menu.x + 2, menu.y + lineHeight*(#list - i))
	end
end