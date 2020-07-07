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
	require "gui/help"
	require "gui/pause"
	require "gui/overlay"
	require "gui/menu"
	require "gui/minimap"
	require "misc/util"
	require "world/cell"

	require "color"
	require "pathfinder"

	love.graphics.setColorMask(true, true, true, true)
	love.graphics.setLineStyle("rough")
	local font = love.graphics.newFont("fonts/18432.ttf", 16)
	love.graphics.setFont(font)

	StartTime = love.timer.getTime()

	Scale = 32
	ScaleLimit = 4096
	WorldSize = {
		width = 64,
		height = 64,
		depth = 8
	}
	Level = WorldSize.depth/2

	Cursor = Cursor()
	Color = Color()
	Log = Log()
	Console = Console()
	Queue = Queue()
	Menu = Menu()
	Help = Help()
	Pause = Pause()
	Minimap = Minimap()
	Overlay = Overlay()

	Cells = {}
	for i = 0, WorldSize.width do
		for j = 0, WorldSize.height do
			for k = 0, WorldSize.depth do
				table.insert(Cells, Cell(j, i, k))
			end
		end
	end

	Block:init()
	Blocks = {}

	local ship1X = 1
	local ship1Y = 1
	for i, row in ipairs(Ship1) do
		for j, kind in ipairs(row) do
			if kind ~= 0 then
				table.insert(Blocks, Block(j + ship1X, i + ship1Y, 4, kind))
			end
		end
	end

	local junk1X = 16
	local junk1Y = 12
	for i, row in ipairs(Junk1) do
		for j, kind in ipairs(row) do
			if kind ~= 0 then
				table.insert(Blocks, Block(j + junk1X, i + junk1Y, 4, kind))
			end
		end
	end

	Seeds = {}
	-- for i = 0, WorldSize.width do
	-- 	for j = 0, WorldSize.height do
	-- 		for k = 0, WorldSize.depth do
	-- 			if love.math.random() > 0.95 then
	-- 				table.insert(Seeds, Seed(j, i, k))
	-- 			end
	-- 		end
	-- 	end
	-- end

	-- build Entities
	Entities = {}

	local base = Base(4, 4, 4)
	table.insert(Entities, base)

	local motor = Motor(base)
	table.insert(Entities, motor)

	local head = Head(base)
	table.insert(Entities, head)

	local manipulator = Manipulator(base)
	table.insert(Entities, manipulator)

	local brain = Brain(base, head)
	table.insert(Entities, brain)

	Pathfinder = Pathfinder(WorldSize.width, WorldSize.height)
end

function love.update(dt)
	if Pause.active then
		return
	end

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
	Help:keypressed(key, scancode, isrepeat)
	Pause:keypressed(key, scancode, isrepeat)
	Menu:keypressed(key, scancode, isrepeat)
	Minimap:keypressed(key, scancode, isrepeat)
	Pathfinder:keypressed(key, scancode, isrepeat)
	Overlay:keypressed(key, scancode, isrepeat)

	if key == "p" then
		table.insert(Seeds, Seed(Cursor.x, Cursor.y, Level))
	end

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

	if key == "escape"
	or key == "q" then
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
	Pathfinder:draw()
	Cursor:draw()
	Menu:draw()
	Console:draw()
	Minimap:draw()
	Overlay:draw()
	Help:draw()
	Pause:draw()

	love.graphics.setColor(Color.white)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", 0, 0, (WorldSize.width + 1)*Scale, (WorldSize.height + 1)*Scale)
end