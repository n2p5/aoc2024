
function main()
    input_file = joinpath(@__DIR__, "input.txt")
    left, right = Int[], Int[]
    open(input_file) do f
        for line in eachline(f)
            row = split(line)
            push!(left, parse(Int, row[1]))
            push!(right, parse(Int, row[2]))
        end
    end

    left = sort!(left)
    right = sort!(right)

    sum = 0::Int
    for (l, r) in zip(left, right)
        sum += abs(r - l)
    end

    print("Part 1: ", sum, "\n")
end

main()


