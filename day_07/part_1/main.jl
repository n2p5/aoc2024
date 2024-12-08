using IterTools
using Base.Threads

function parse_line(line::String)::Tuple{Int,Vector{Int}}
    s = split(line, ":")
    answer = parse(Int, s[1])
    values = parse.(Int, split(s[2]))
    return (answer, values)
end

function findcombo(values::Vector{Int}, answer::Int)::Int
    combos = IterTools.product(fill([+, *], length(values) - 1)...)
    for combo in combos
        v = copy(values)
        result = popfirst!(v)
        for fn in combo
            if result > answer
                break
            end
            result = fn(result, popfirst!(v))
        end
        if result == answer
            return result
        end
    end
    return 0
end

function main()
    filepath = joinpath(@__DIR__, "input.txt")
    lines = readlines(filepath)
    sum = 0
    zerocount = 0
    for line in lines
        answer, values = parse_line(line)
        result = findcombo(values, answer)
        if result == 0
            zerocount += 1
        end
        sum += result
    end
    println("Sum: ", sum)
    println("Zero count: ", zerocount)
    println("Total lines: ", length(lines))
end

main()