
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
    if nextvalue == '#' || nextvalue == '0'
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

function makegridpath(grid::CharGrid, start::CartesianIndex{2})::CharGrid
    g = copy(grid)
    d = grid[start]
    p = CartesianIndex(start)
    while !isnothing(p)
        g, p, d = move!(g, p, d)
    end
    return g
end

function hasloop(grid::CharGrid, start::CartesianIndex{2})::Bool
    g = copy(grid)
    d = g[start]
    p = CartesianIndex(start)
    visited = Dict{CartesianIndex{2},Set{Char}}()
    while !isnothing(p)
        g, p, d = move!(g, p, d)
        if isnothing(p)
            continue
        end
        if haskey(visited, p)
            if d in visited[p]
                # savegrid(g, joinpath(@__DIR__, "output.txt"))
                return true
            end
            push!(visited[p], d)
        else
            visited[p] = Set([d])
        end
    end
    return false
end

function main()
    filepath = joinpath(@__DIR__, "input.txt")
    grid = newgridfromfile(filepath)
    start_pos = findfirst(x -> x in ['^', 'v', '<', '>'], grid)
    grid_path = makegridpath(grid, start_pos)

    # find all the positions where we have traveled
    traveled = findall(x -> x == 'X', grid_path)

    # remove the start position from the traveled positions
    filtered_traveled = filter(pos -> pos != start_pos, traveled)

    loop_count = 0

    for pos in filtered_traveled
        grid_test = copy(grid)
        grid_test[pos] = '0'

        loop_count += hasloop(grid_test, start_pos) ? 1 : 0
    end
    println("possible loops: ", length(filtered_traveled))
    println("Loop count:     ", loop_count)
end


main()