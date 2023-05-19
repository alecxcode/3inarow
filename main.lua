Class = require "class"
require "grid"
require "display"

math.randomseed(os.time())
local voidchr = ' '
local size = 10
local grid = Grid(size, voidchr)
local view = Display()
local exres = '' -- this is a message about move result
local mixcounter = 0

-- main game cycle
while view.gamestate ~= "Player quit" do
	-- this dump shows normal grid without voids and before mixing
	view:dump(grid.matrix, exres, true)
	-- mixing if necessary (extremely rarely happers on large grids)
	local mix = grid:mix()
	while mix do
		mixcounter = mixcounter + 1
		print('\nMixing...')
		mix = grid:mix()
		-- this dump updates the grid after mixing
		view:dump(grid.matrix, exres, true)
		if mixcounter > 1000 then
			print("Game over: cannot create playable grid")
			os.exit()
		end
	end
	mixcounter = 0
	-- player makes move
	view:move()
	-- tick updates the grid internally
	exres = grid:tick(view.x, view.y, view.direction)
	if startswith(view.gamestate, "Wrong input") then
		exres = ''
	end
	if startswith(exres, "moved") then
		-- this dump shows temporary voids for better gameplay
		view:dump(grid.matrix, exres, false)
		-- shift could be part of a tick
		-- but for user experience it was separated to fill voids later
		grid:shift()
		-- some time pause to show voids
		sleep(1)
	end
end
