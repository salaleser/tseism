function love.load()
	Object = require "libs/classic"

	require "data/ships"
	require "engine/log"
	require "engine/queue"
	require "engine/task"
	require "entities/base"
	require "entities/block"
	require "entities/brain"
	require "entities/head"
	require "entities/manipulator"
	require "entities/motor"
	require "entities/seed"
	require "gui/console"
	require "gui/cursor"
	require "gui/menu"
	require "gui/minimap"
	require "misc/util"
	require "world/cell"

	love.graphics.setLineStyle("rough")
	local font = love.graphics.newFont("fonts/18432.ttf", 16)
	love.graphics.setFont(font)

	StartTime = love.timer.getTime()

	Scale = 32
	ScaleLimit = 4096
	WorldSize = {
		width = 128,
		height = 128,
		depth = 8
	}
	Level = WorldSize.depth/2

	Cursor = Cursor(WorldSize.width/2, WorldSize.height/2)
	Log = Log()
	Console = Console()
	Menu = Menu()
	Minimap = Minimap()

	Cells = {}
	for i = 0,WorldSize.width do
		for j = 0,WorldSize.height do
			for k = 0,WorldSize.depth do
				table.insert(Cells, Cell(j, i, k))
			end
		end
	end

	Block:init()
	Blocks = {}
	for i, row in ipairs(Ship1) do
		for j, kind in ipairs(row) do
			if kind ~= 0 then
				table.insert(Blocks, Block(j, i, 4, kind))
			end
		end
	end

	Seeds = {}
	for i = 0, WorldSize.width do
		for j = 0, WorldSize.height do
			for k = 0, WorldSize.depth do
				if love.math.random() > 0.95 then
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
	for _, v in ipairs(Cells) do
		v:update(dt)
	end

	for _, v in ipairs(Blocks) do
		v:update(dt)
	end

	for _, v in ipairs(Seeds) do
		v:update(dt)
	end

	for _, v in ipairs(Entities) do
		v:update(dt)
	end

	Cursor:update(dt)
	Log:update(dt)
end

function love.keypressed(key, scancode, isrepeat)
	Cursor:keypressed(key, scancode, isrepeat)
	Console:keypressed(key, scancode, isrepeat)
	Menu:keypressed(key, scancode, isrepeat)
	Minimap:keypressed(key, scancode, isrepeat)

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
		if Scale > ScaleLimit then
			Scale = ScaleLimit
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

	if key == "space" then
		love.event.wait()
	end

	if key == "escape" then
		love.event.quit()
	end

	if key == "r" then
		love.event.quit("restart")
	end
end

function love.draw()
	for _, v in ipairs(Cells) do
		if v.z == Level then
			v:draw()
		end
	end

	for _, v in ipairs(Blocks) do
		if v.z == Level then
			v:draw()
		end
	end

	for _, v in ipairs(Seeds) do
		if v.z == Level then
			v:draw()
		end
	end

	for _, v in ipairs(Entities) do
		if v.z == Level then
			v:draw()
		end
	end

	-- GUI --
	Cursor:draw()
	Console:draw()
	Menu:draw()
	Minimap:draw()

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", 0, 0, (WorldSize.width + 1)*Scale, (WorldSize.height + 1)*Scale)
end