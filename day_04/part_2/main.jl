
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

function countxmas(g::CharGrid, i::Int, j::Int)::Int
    leftdiag = Set{Char}()
    rightdiag = Set{Char}()

    try
        push!(leftdiag, g[i-1, j-1])
        push!(leftdiag, g[i+1, j+1])

        push!(rightdiag, g[i-1, j+1])
        push!(rightdiag, g[i+1, j-1])
    catch
        return 0
    end

    ref = Set(['M', 'S'])

    if rightdiag == ref && leftdiag == ref
        return 1
    else
        return 0
    end
end

function main()
    filepath = joinpath(@__DIR__, "input.txt")
    grid = newgridfromfile(filepath)

    xmas_counter = 0::Int

    for (i, row) in enumerate(eachrow(grid))
        for (j, v) in enumerate(row)
            if v == 'A'
                count = countxmas(grid, i, j)
                println("found 'A' one at $i, $j")
                xmas_counter += count
            end
        end
    end

    println(xmas_counter)

end


main()