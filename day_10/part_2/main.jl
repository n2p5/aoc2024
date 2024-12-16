const IntGrid = Array{Int,2}

function newgridfromfile(file::String)::IntGrid
    file_content = read(file, String)
    lines = split(file_content, "\n")
    height = length(lines)
    width = length(lines[1])
    grid = IntGrid(undef, height, width)
    for i in 1:height
        grid[i, :] = parse.(Int, collect(lines[i]))
    end
    return grid
end

function crawl!(grid::IntGrid, position::CartesianIndex{2}, step::Int, endpoints::Dict{CartesianIndex{2},Int})
    v = Nothing
    try
        v = grid[position]
    catch
        return
    end
    if v != step
        return
    end
    if v == 9
        if !haskey(endpoints, position)
            endpoints[position] = 1
        else
            endpoints[position] += 1
        end
        return
    end
    crawl!(grid, CartesianIndex(position[1] - 1, position[2]), step + 1, endpoints)
    crawl!(grid, CartesianIndex(position[1] + 1, position[2]), step + 1, endpoints)
    crawl!(grid, CartesianIndex(position[1], position[2] - 1), step + 1, endpoints)
    crawl!(grid, CartesianIndex(position[1], position[2] + 1), step + 1, endpoints)
end

function possible_paths(grid::IntGrid, position::CartesianIndex{2})::Int
    # TODO: TBD, here we need to implement the logic to find the possible paths
    endpoints = Dict{CartesianIndex{2},Int}()
    crawl!(grid, position, 0, endpoints)

    return sum(values(endpoints))
end


function main()
    filepath = joinpath(@__DIR__, "input.txt")
    grid = newgridfromfile(filepath)

    trailheads = findall(x -> x == 0, grid)

    sum = 0
    for trailhead in trailheads
        sum += possible_paths(grid, trailhead)
    end

    println(sum)
end

main()