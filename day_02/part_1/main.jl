

function issafe(row::Array{Int,1})
    prev = nothing
    slope = nothing
    for (i, item) in enumerate(row)
        if i == 1
            prev = item
            continue
        end
        if i == 2
            if item > prev
                slope = "p" # positive
            elseif item < prev
                slope = "n" # negative
            else
                break # slope is flat, not safe.
            end
        end
        # no change is unsafe
        if prev == item
            break
        end
        if slope == "p" && item < prev
            break
        end
        if slope == "n" && item > prev
            break
        end
        if abs(item - prev) > 3
            break
        end
        if i == length(row)
            return true
        end
        prev = item
    end
    return false
end


function main()
    input_file = joinpath(@__DIR__, "input.txt")
    safecount = 0::Int
    open(input_file) do f
        for line in eachline(f)
            row = map(x -> parse(Int, x), split(line))
            safecount += issafe(row) ? 1 : 0
        end
    end
    println("safecount: ", safecount)
end

main()