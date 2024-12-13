

function diskmap(input::Vector{Int})::Vector{Int}
    isfile = true
    current_id = 0
    disk = Vector{Int}()
    for v in input
        if isfile
            for i in 1:v
                push!(disk, current_id)
            end
            current_id += 1
            isfile = false
        else
            for i in 1:v
                push!(disk, -1)
            end
            isfile = true
        end
    end
    return disk
end

function checksum(disk::Vector{Int})::Int
    sum = 0
    for (i, v) in enumerate(disk)
        if v == -1
            break
        end
        sum += v * (i - 1)
    end
    return sum
end

function compact_disk(disk::Vector{Int})::Vector{Int}
    result = copy(disk)

    for i in length(result):-1:1
        v = result[i]
        if v == -1
            continue
        end
        for (j, d) in enumerate(result[1:i])
            if d == -1
                result[j] = v
                result[i] = -1
                break
            end
        end
    end
    return result
end



function main()
    filename = "input.txt"
    input = readlines(joinpath(@__DIR__, filename))[1]
    data = parse.(Int, collect(input))

    disk = diskmap(data)
    compressed = compact_disk(disk)
    println("checksum: ", checksum(compressed))
end

main()