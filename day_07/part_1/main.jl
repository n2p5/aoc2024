using IterTools

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
    sum = 0
    for (i, line) in enumerate(eachline(filepath))
        answer, values = parse_line(line)
        sum += findcombo(values, answer)
    end
    println("Sum: ", sum)
end

main()