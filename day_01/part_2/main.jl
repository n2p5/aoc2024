
function main()
    input_file = joinpath(@__DIR__, "input.txt")
    left, right = Int[], Int[]
    frequency_map = Dict{Int,Int}()
    open(input_file) do f
        for line in eachline(f)
            row = split(line)
            left_num = parse(Int, row[1])
            right_num = parse(Int, row[2])
            push!(left, left_num)
            push!(right, right_num)
            if haskey(frequency_map, right_num)
                frequency_map[right_num] += 1
            else
                frequency_map[right_num] = 1
            end
        end
    end

    sum = 0::Int
    for l in left
        if haskey(frequency_map, l)
            sum += frequency_map[l] * l
        end
    end
    print("Part 2: ", sum, "\n")
end

main()
