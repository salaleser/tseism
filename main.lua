function love.load()
	Object = require "classic"
	require "task"
	require "cursor"
	require "cell"
	require "seed"
	require "base"

	-- Body parts
	require "head"

	-- Modules
	require "brain"
	require "motor"

	StartTime = love.timer.getTime()

	Queue = {}

	Scale = 64
	WorldSize = {
		width = 16,
		height = 16,
		depth = 8
	}

	Cursor = Cursor(WorldSize.width/2, WorldSize.height/2)
	Level = WorldSize.depth/2

	Cells = {}
	for i = 0,WorldSize.width do
		for j = 0,WorldSize.height do
			for k = 0,WorldSize.depth do
				table.insert(Cells, Cell(i, j, k))
			end
		end
	end

	Seeds = {}
	for i = 0,WorldSize.width do
		for j = 0,WorldSize.height do
			for k = 0,WorldSize.depth do
				if love.math.random() > 0.95 then
					table.insert(Seeds, Seed(i, j, k))
				end
			end
		end
	end

	Entities = {}

	local base = Base(4, 4, 4)
	table.insert(Entities, base)

	local motor = Motor(base)
	table.insert(Entities, motor)

	local head = Head(base)
	table.insert(Entities, head)

	local brain = Brain(head)
	table.insert(Entities, brain)
end

function love.update(dt)
	for i,v in ipairs(Cells) do
		v:update()
	end

	for i,v in ipairs(Seeds) do
		v:update()
	end

	for i,v in ipairs(Entities) do
		v:update()
	end

	for i,v in ipairs(Queue) do
		v:update()
	end

	Cursor:update()

	Console = love.timer.getFPS()
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
		if Scale > 2 then
			Scale = Scale / 2
		end
	elseif key == "=" then
		if Scale < 512 then
			Scale = Scale * 2
		end
	end
end

function love.draw()
	for i,v in ipairs(Cells) do
		if v.z == Level then
			v:draw()
		end
	end

	for i,v in ipairs(Seeds) do
		if v.z == Level then
			v:draw()
		end
	end

	for i,v in ipairs(Entities) do
		if v.z == Level then
			v:draw()
		end
	end

	for i,v in ipairs(Queue) do
		v:draw()
	end

	Cursor:draw()

	local lineSize = 12
	love.graphics.setColor(1, 1, 1, 0.9)
	love.graphics.print("Level: " .. Level, 0, (WorldSize.height + 1)*Scale + lineSize*0)
	love.graphics.print(Console, 0, (WorldSize.height + 1)*Scale + lineSize*1)
end