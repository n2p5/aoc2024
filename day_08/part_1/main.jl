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

function tryset!(grid::CharGrid, index::CartesianIndex, value::Char)
    try
        grid[index] = value
    catch
    end
end

function mark_antinodes!(grid::CharGrid, locations::Array{CartesianIndex{2},1})

    while !isempty(locations)
        current = popfirst!(locations)
        for next in locations
            a1 = (current - next) + current
            a2 = (next - current) + next
            tryset!(grid, a1, 'X')
            tryset!(grid, a2, 'X')
        end
    end
end

function main()
    filepath = joinpath(@__DIR__, "input.txt")
    antenna_grid = newgridfromfile(filepath)
    height, width = size(antenna_grid)
    antinode_grid = CharGrid(undef, height, width)

    unique_antennas = Set(antenna_grid)
    # remove '.' from the set
    delete!(unique_antennas, '.')

    for antenna in unique_antennas
        locations = findall(x -> x == antenna, antenna_grid)
        mark_antinodes!(antinode_grid, locations)
    end

    antinode_locations = findall(x -> x == 'X', antinode_grid)
    println("Number of antinodes: ", length(antinode_locations))


end

main()