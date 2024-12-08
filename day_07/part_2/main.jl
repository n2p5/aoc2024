using IterTools
using Base.Threads

function parse_line(line::String)::Tuple{Int,Vector{Int}}
    s = split(line, ":")
    answer = parse(Int, s[1])
    values = parse.(Int, split(s[2]))
    return (answer, values)
end

function concat(a::Int, b::Int)::Int
    return parse(Int, string(a, b))
end

function findcombo(values::Vector{Int}, answer::Int, fns)::Int
    combos = IterTools.product(fill(fns, length(values) - 1)...)
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
    retry_lines = Vector{String}()
    precalcsum = 0

    for line in lines
        answer, values = parse_line(line)
        result = findcombo(values, answer, [+, *])
        if result == 0
            push!(retry_lines, line)
        end
        precalcsum += result
    end
    println("Precalc sum: ", precalcsum)

    sum = Atomic{Int64}(precalcsum)
    Threads.@threads for line in retry_lines
        println("reading line: ", line)
        answer, values = parse_line(line)
        Threads.atomic_add!(sum, findcombo(values, answer, [+, *, concat]))
    end
    println("Sum: ", sum)
end

main()