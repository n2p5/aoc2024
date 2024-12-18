


function getrules(filepath::String)::Dict{Int,Set{Int}}
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

function getupdates(filepath::String)::Vector{Vector{Int}}
    updates = Vector{Vector{Int}}()
    open(filepath) do file
        for line in eachline(file)
            push!(updates, parse.(Int, split(line, ",")))
        end
    end
    return updates
end

# iscorrect checks loops through each page in the update and checks if the current page has a rule that
# forbids the previous pages. If it does, it returns false, otherwise it returns true.
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

# correctupdate recursively swaps pages until the update is correct. It does this by checking if the current page
# has a rule that forbids the previous pages. If it does, it swaps the current page with the first previous page that
# is forbidden by the current page. It then runs recursively until the update is correct.
function correctupdate(rules::Dict{Int,Set{Int}}, update::Vector{Int})::Vector{Int}
    for (i, page) in enumerate(update)
        if i == 1 # skip first page
            continue
        end
        if haskey(rules, page)
            for (j, prev_page) in enumerate(update[1:i-1])
                if prev_page in rules[page]
                    # swap pages and run recursively until correct
                    update[i], update[j] = update[j], update[i]
                    return correctupdate(rules, update)
                end
            end
        end
    end
    return update
end


function main()
    rules = getrules(joinpath(@__DIR__, "rules.txt"))
    updates = getupdates(joinpath(@__DIR__, "update.txt"))

    sum = 0::Int

    for update in updates
        if !iscorrect(rules, update)
            corrected = correctupdate(rules, update)
            sum += corrected[Int((length(corrected) + 1) / 2)]
        end
    end

    println("sum: ", sum)
end

main()