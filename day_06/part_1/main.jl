
const CharGrid = Array{Char,2}

function newgridfromfile(file::String)::CharGrid
    file_content = read(file, String)
    lines = split(file_content, "\n")
    height = length(lines)
    width = length(lines[1])
    grid = CharGrid(undef, height, width)
    for i in 1:height
        grid[i, :] = collect(lines[i])
    end
    return grid
end

function getnext(position::CartesianIndex{2}, direction::Char)::CartesianIndex{2}
    x, y = Tuple(position)
    if direction == '^'
        return CartesianIndex(x - 1, y)
    elseif direction == 'v'
        return CartesianIndex(x + 1, y)
    elseif direction == '<'
        return CartesianIndex(x, y - 1)
    elseif direction == '>'
        return CartesianIndex(x, y + 1)
    end
end

function rotate(direction::Char)::Char
    if direction == '^'
        return '>'
    elseif direction == 'v'
        return '<'
    elseif direction == '<'
        return '^'
    elseif direction == '>'
        return 'v'
    end
end

function move!(grid::CharGrid, position::CartesianIndex{2}, direction::Char)
    next = getnext(position, direction)
    nextvalue = nothing
    try
        nextvalue = grid[next]
    catch
        nextvalue = nothing
    end
    if isnothing(nextvalue)
        grid[position] = 'X'
        return (grid, nothing, direction)
    end
    if nextvalue == '#'
        return (grid, position, rotate(direction))
    end
    grid[position] = 'X'
    return (grid, next, direction)
end

function savegrid(grid::CharGrid, filepath::String)
    open(filepath, "w") do file
        for row in eachrow(grid)
            for v in row
                write(file, v)
            end
            write(file, "\n")
        end
    end
end

function main()
    filepath = joinpath(@__DIR__, "input.txt")
    grid = newgridfromfile(filepath)

    position = findfirst(x -> x in ['^', 'v', '<', '>'], grid)

    direction = grid[position]

    while !isnothing(position)
        grid, position, direction = move!(grid, position, direction)
    end

    traveled = findall(x -> x == 'X', grid)
    println(length(traveled))

    savegrid(grid, joinpath(@__DIR__, "output.txt"))

end


main()