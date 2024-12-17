
function change_stone(n::Int)::Vector{Int}
    if n == 0
        return [1]
    end
    ns = string(n)
    if length(ns) % 2 == 0
        mid = div(length(ns), 2)
        left = parse(Int, ns[1:mid])
        right = parse(Int, ns[mid+1:end])
        return [left, right]
    end
    return [n * 2024]
end


function main()
    filepath = joinpath(@__DIR__, "input.txt")
    stones = parse.(Int, split(readlines(filepath)[1]))

    blink_count = 75

    println("Stones: ", stones)

    for blink in 1:blink_count
        println("Blink: ", blink)
        next_stones = []
        for stone in stones
            new_stones = change_stone(stone)
            append!(next_stones, new_stones...)
        end
        stones = next_stones
        println("Stone Count: ", length(stones))
    end

end

main()