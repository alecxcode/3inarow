require "common"

Display = Class {}

function Display:init()
    self.gamestate = "Game started"
    self.command = 'undefined'
    self.x = nil
    self.y = nil
    self.direction = 'undefined'
end

function Display:move()
    local inpstr = io.read()
    local data = splitstr(inpstr)
    if data and data[1] == 'q' then
        self.gamestate = "Player quit"
        print(self.gamestate)
        return
    end
    if #data < 4 or data[1] ~= 'm' then
        self.gamestate = "Wrong input, try again"
    elseif data[1] == 'm' then
        self.command = data[1]
        self.x = tonumber(data[2])
        self.y = tonumber(data[3])
        if not checkcoords(self.x, self.y) then
            self.x = nil
            self.y = nil
            self.gamestate = "Wrong input, try again"
            return
        end
        self.direction = 'undefined'
        if data[4] == 'u' then
            self.direction = 'up'
        elseif data[4] == 'd' then
            self.direction = 'down'
        elseif data[4] == 'l' then
            self.direction = 'left'
        elseif data[4] == 'r' then
            self.direction = 'right'
        else
            self.direction = 'undefined'
            self.gamestate = "Wrong input, try again"
            return
        end
        self.gamestate = string.format("Moving the crystal: (%d, %d) %s -> ", self.x, self.y, self.direction)
    else
        self.gamestate = "Wrong input, try again"
    end
end

function Display:dump(grid, exres, entercommand)
    if not os.execute("clear") then
        os.execute("cls")
    end
    local res =
    "---3 in a row Game---\ntype q to quit;\ntype m x y d to move:\nx, y - coordinates,\nd - direction {l,r,u,d},\ne.g. m 3 5 u\n\n "
    for i = 1, #grid do
        res = res .. ' ' .. tostring(i - 1)
    end
    res = res .. '\n '
    for i = 1, #grid do
        res = res .. ' ' .. '-'
    end
    res = res .. '\n'
    for i = 1, #grid do
        local elem = tostring(i - 1) .. " " .. table.concat(grid[i], ' ') .. '\n'
        res = res .. elem
    end
    print(res)
    if entercommand then
        io.write(self.gamestate .. exres .. "\nEnter a command > ")
    end
end
