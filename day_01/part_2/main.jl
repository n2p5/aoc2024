
function main()
    input_file = joinpath(@__DIR__, "input.txt")
    left, right = Int[], Int[]
    freq = Dict{Int,Int}()
    open(input_file) do f
        for line in eachline(f)
            row = split(line)
            push!(left, parse(Int, row[1]))
            push!(right, parse(Int, row[2]))
            freq[right[end]] = get(freq, right[end], 0) + 1
        end
    end

    sum = 0::Int
    for l in left
        sum += get(freq, l, 0) * l
    end
    print("Part 2: ", sum, "\n")
end

main()
