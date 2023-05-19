--map is a common higher-order function to map over an array
function map(func, arr)
    local res = {}
    for i, v in ipairs(arr) do
        res[i] = func(v)
    end
    return res
end

-- shiftvalue shifts the value and starts from the beginning if necessary
function shiftvalue(val)
    if val == 'A' then
        val = 'B'
    elseif val == 'B' then
        val = 'C'
    elseif val == 'C' then
        val = 'D'
    elseif val == 'D' then
        val = 'E'
    elseif val == 'E' then
        val = 'F'
    elseif val == 'F' then
        val = 'A'
    end
    return val
end

-- randomvalue gets the next random value from the list
function listrandomvalue(list, incorrectval)
    local index = math.random(1, #list)
    local crystal = list[index]
    table.remove(list, index)
    if incorrectval then
        table.insert(list, incorrectval)
    end
    return crystal
end

-- checkback ensures that 3 cells in a row do not contain the same value
function checkback(grid, i, j, list)
    if j > 2 then
        while grid[i][j] == grid[i][j - 1] and grid[i][j] == grid[i][j - 2] do
            if list then
                grid[i][j] = listrandomvalue(list, grid[i][j])
            else
                grid[i][j] = shiftvalue(grid[i][j])
            end
        end
    end
end

-- checkabove ensures that 3 cells in a column do not contain the same value
function checkabove(grid, i, j, list)
    if i > 2 then
        while grid[i][j] == grid[i - 1][j] and grid[i][j] == grid[i - 2][j] do
            if list then
                grid[i][j] = listrandomvalue(list, grid[i][j])
            else
                grid[i][j] = shiftvalue(grid[i][j])
            end
            checkback(grid, i, j)
        end
    end
end

-- checkcoords ensures that x and y coords are within the matrix
function checkcoords(x, y)
    if not x or not y then return false end
    local resx = false
    local resy = false
    for i = 0, 9 do
        if x == i then resx = true end
        if y == i then resy = true end
    end
    if resx and resy then return true end
    return false
end

-- checkline verifies the possibility of a move
function checkline(nx, line, gridsize)
    for i = 1, gridsize - 2 do
        if line[i] == line[i + 1] and line[i] == line[i + 2] and nx >= i and nx <= i + 2 then
            return true
        end
    end
    return false
end

-- checkcolumn verifies the possibility of a move
function checkcolumn(nx, ny, grid, gridsize)
    for i = 1, gridsize - 2 do
        if grid[i][nx] == grid[i + 1][nx] and grid[i][nx] == grid[i + 2][nx] and ny >= i and ny <= i + 2 then
            return true
        end
    end
    return false
end

-- checkcomb verifies the possibility of a move (reserved for expanded combinations)
function checkcomb(ny, nx, grid, gridsize)
    return false
end

-- splitstr splits a string into a table based on the space separator
function splitstr(inpstr)
    local res = {}
    for s in string.gmatch(inpstr, "[^ ]+") do
        table.insert(res, s)
    end
    return res
end

-- sleep waits for a number of seconds
function sleep(sec)
    local t = os.clock()
    while os.clock() - t <= sec do
    end
end

function startswith(str, start)
    return str:sub(1, #start) == start
end

-- matrixcontainsvoids checks if matrix has removed crystals
function matrixcontainsvoids(matrix, voidchr)
    for i = 1, #matrix do
        for j = 1, #matrix[i] do
            if matrix[i][j] == voidchr then
                return true
            end
        end
    end
    return false
end

-- flattenmatrix makes one array from a 2D array
function flattenmatrix(matrix)
    local list = {}
    for i = 1, #matrix do
        for j = 1, #matrix[i] do
            table.insert(list, matrix[i][j])
        end
    end
    return list
end
