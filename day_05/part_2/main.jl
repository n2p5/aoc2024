


function getrules(filepath)::Dict{Int,Set{Int}}
    rules = Dict{Int,Set{Int}}()
    open(filepath) do file
        for line in eachline(file)
            str_a, str_b = split(line, "|")
            a = parse(Int, str_a)
            b = parse(Int, str_b)
            if haskey(rules, a)
                push!(rules[a], b)
            else
                rules[a] = Set([b])
            end
        end
    end
    return rules
end

function getupdates(filepath)::Vector{Vector{Int}}
    updates = Vector{Vector{Int}}()
    open(filepath) do file
        for line in eachline(file)
            push!(updates, parse.(Int, split(line, ",")))
        end
    end
    return updates
end

# use to return middle number update[Int((length(update) + 1) / 2)]

function iscorrect(rules::Dict{Int,Set{Int}}, update::Vector{Int})::Bool
    for (i, page) in enumerate(update)
        if haskey(rules, page)
            prev_pages = Set(update[1:i])
            if !isempty(intersect(rules[page], prev_pages))
                return false
            end
        end
    end
    return true
end

function main()
    rules = getrules(joinpath(@__DIR__, "rules.txt"))
    updates = getupdates(joinpath(@__DIR__, "update.txt"))

    sum = 0::Int

    incorrect_updates = Vector{Vector{Int}}()

    for update in updates
        if !iscorrect(rules, update)
            push!(incorrect_updates, update)
        end
    end

    for update in incorrect_updates
        println(update)
    end

    println(length(incorrect_updates))
    println(sum)
end

main()