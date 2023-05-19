require "common"

Grid = Class {}

function Grid:init(size, voidchr)
    self.size = size
    self.voidchr = voidchr
    self.matrix = {}
    for i = 1, self.size do
        self.matrix[i] = {}
        for j = 1, self.size do
            self.matrix[i][j] = string.char(math.random(65, 70))
            checkback(self.matrix, i, j)
            checkabove(self.matrix, i, j)
        end
    end
end

function Grid:tick(x, y, direction)
    if x and y and direction ~= 'undefined' then
        x = x + 1
        y = y + 1
        if (direction == 'up' and y <= 1) or (direction == 'down' and y >= self.size) or (direction == 'left' and x <= 1) or (direction == 'right' and x >= self.size) then
            return "move not possible"
        end
        local crystal = self.matrix[y][x]
        local nx = x
        local ny = y
        if direction == 'up' then
            ny = ny - 1
        elseif direction == 'down' then
            ny = ny + 1
        elseif direction == 'left' then
            nx = nx - 1
        elseif direction == 'right' then
            nx = nx + 1
        end
        local replacedcrystal = self.matrix[ny][nx]
        self.matrix[ny][nx] = crystal
        self.matrix[y][x] = replacedcrystal
        if checkline(nx, self.matrix[ny], self.size) or checkcolumn(nx, ny, self.matrix, self.size) or checkcomb() then
            self:remove()
            return "moved: " .. crystal .. ' ' .. direction
        else
            self.matrix[y][x] = crystal
            self.matrix[ny][nx] = replacedcrystal
            return "move not possible"
        end
    else
        return ''
    end
end

function Grid:remove()
    -- horisontal removal
    for i = 1, self.size do
        local val = self.matrix[i][1]
        local indexes = { 1 }
        for j = 2, self.size do
            if self.matrix[i][j] == val then
                table.insert(indexes, j)
            else
                if indexes and #indexes >= 3 then
                    for k, v in pairs(indexes) do self.matrix[i][v] = self.voidchr end
                end
                val = self.matrix[i][j]
                indexes = { j }
            end
            if indexes and #indexes >= 3 then
                for k, v in pairs(indexes) do self.matrix[i][v] = self.voidchr end
            end
        end
    end
    -- vertical removal
    for i = 1, self.size do
        local val = self.matrix[1][i]
        local indexes = { 1 }
        for j = 2, self.size do
            if self.matrix[j][i] == val then
                table.insert(indexes, j)
            else
                if indexes and #indexes >= 3 then
                    for k, v in pairs(indexes) do self.matrix[v][i] = self.voidchr end
                end
                val = self.matrix[j][i]
                indexes = { j }
            end
            if indexes and #indexes >= 3 then
                for k, v in pairs(indexes) do self.matrix[v][i] = self.voidchr end
            end
        end
    end
end

function Grid:shift()
    repeat
        for i = self.size, 1, -1 do
            for j = 1, self.size do
                if i > 1 and self.matrix[i][j] == self.voidchr then
                    self.matrix[i][j] = self.matrix[i - 1][j]
                    self.matrix[i - 1][j] = self.voidchr
                elseif i == 1 and self.matrix[i][j] == self.voidchr then
                    self.matrix[i][j] = string.char(math.random(65, 70))
                end
            end
        end
        self:remove()
    until not matrixcontainsvoids(self.matrix, self.voidchr)
end

function Grid:mix()
    -- discover if the grid needs the mix
    for y = 1, self.size - 2 do
        for x = 1, self.size - 2 do
            -- vertical search
            if self.matrix[y][x + 1] == self.matrix[y + 1][x] and self.matrix[y][x + 1] == self.matrix[y + 2][x + 1] then return false end
            if self.matrix[y][x] == self.matrix[y + 1][x + 1] and self.matrix[y][x] == self.matrix[y + 2][x] then return false end
            if self.matrix[y][x + 1] == self.matrix[y + 1][x] and self.matrix[y][x + 1] == self.matrix[y][x + 2] then return false end
            if self.matrix[y + 1][x] == self.matrix[y + 1][x + 1] and self.matrix[y + 1][x] == self.matrix[y][x + 2] then return false end
            if self.matrix[y][x] == self.matrix[y + 1][x] and self.matrix[y][x] == self.matrix[y + 2][x + 1] then return false end
            if self.matrix[y][x] == self.matrix[y + 1][x + 1] and self.matrix[y][x] == self.matrix[y + 2][x + 1] then return false end
            if y < self.size - 2 then
                if self.matrix[y][x] == self.matrix[y + 1][x] and self.matrix[y][x] == self.matrix[y + 3][x] then return false end
                if self.matrix[y][x] == self.matrix[y + 2][x] and self.matrix[y][x] == self.matrix[y + 3][x] then return false end
            end
            -- hirozontal search
            if self.matrix[y + 1][x] == self.matrix[y][x + 1] and self.matrix[y + 1][x] == self.matrix[y + 1][x + 2] then return false end
            if self.matrix[y][x] == self.matrix[y + 1][x + 1] and self.matrix[y][x] == self.matrix[y][x + 2] then return false end
            if self.matrix[y + 1][x] == self.matrix[y + 1][x + 1] and self.matrix[y + 1][x] == self.matrix[y][x + 2] then return false end
            if self.matrix[y + 1][x] == self.matrix[y][x + 1] and self.matrix[y + 1][x] == self.matrix[y][x + 2] then return false end
            if self.matrix[y][x] == self.matrix[y + 1][x + 1] and self.matrix[y][x] == self.matrix[y + 1][x + 2] then return false end
            if self.matrix[y][x] == self.matrix[y][x + 1] and self.matrix[y][x] == self.matrix[y + 1][x + 2] then return false end
            if x < self.size - 2 then
                if self.matrix[y][x] == self.matrix[y][x + 1] and self.matrix[y][x] == self.matrix[y][x + 3] then return false end
                if self.matrix[y][x] == self.matrix[y][x + 2] and self.matrix[y][x] == self.matrix[y][x + 3] then return false end
            end
        end
    end
    -- make the mix
    local list = flattenmatrix(self.matrix)
    for i = 1, self.size do
        self.matrix[i] = {}
        for j = 1, self.size do
            self.matrix[i][j] = listrandomvalue(list)
            checkback(self.matrix, i, j, list)
            checkabove(self.matrix, i, j, list)
        end
    end
    return true
end
