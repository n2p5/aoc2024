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

function possible_paths(grid::CharGrid, position::CartesianIndex{2})::Int
    # TODO: TBD, here we need to implement the logic to find the possible paths
    return 1
end


function main()
    filepath = joinpath(@__DIR__, "input.txt")
    grid = newgridfromfile(filepath)

    trailheads = findall(x -> x == '0', grid)

    sum = 0
    for trailhead in trailheads
        sum += possible_paths(grid, trailhead)
    end

    # println(grid)
    println(trailheads)
    println(sum)
end

main()