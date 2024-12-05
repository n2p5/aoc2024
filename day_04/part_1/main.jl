
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

function matcher(g::CharGrid, i::Int, j::Int, xop::Int, yop::Int)::Int
    chars = [' ', ' ', ' ', ' ']::Array{Char,1}
    for k in 0:3
        try
            chars[k+1] = g[i+(k*xop), j+(k*yop)]
        catch
            continue
        end
    end
    return chars == ['X', 'M', 'A', 'S'] ? 1 : 0
end

function countxmas(g::CharGrid, i::Int, j::Int)::Int
    xmas_counter = 0::Int
    ops = [
        (-1, 0) # left
        (1, 0) # right
        (0, -1) # up
        (0, 1) # down
        (-1, -1) # up-left
        (1, -1) # up-right
        (-1, 1) # down-left
        (1, 1) # down-right
    ]
    for (xop, yop) in ops
        xmas_counter += matcher(g, i, j, xop, yop)
    end
    return xmas_counter
end

function main()
    filepath = joinpath(@__DIR__, "input.txt")
    grid = newgridfromfile(filepath)

    xmas_counter = 0::Int

    for (i, row) in enumerate(eachrow(grid))
        for (j, v) in enumerate(row)
            if v == 'X'
                count = countxmas(grid, i, j)
                xmas_counter += count
            end
        end
    end

    println(xmas_counter)

end


main()