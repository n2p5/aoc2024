

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
            continue
        end
        sum += v * (i - 1)
    end
    return sum
end


function compact_disk(disk::Vector{Int})::Vector{Int}
    result = copy(disk)
    move_buffer = Vector{Int}()

    for i in length(result):-1:1
        if i == 1
            break
        end
        v = result[i]
        if v == -1
            move_buffer = Vector{Int}()
            continue
        end
        if length(move_buffer) == 0 || v == move_buffer[1]
            push!(move_buffer, v)
        end
        if result[i-1] == v
            continue
        end
        if result[i-1] != v
            for (j, d) in enumerate(result[1:i])
                offset = j + length(move_buffer) - 1
                if all(x -> x == -1, result[j:offset])
                    for k in j:offset
                        result[k] = move_buffer[1]
                    end
                    for k in i:i+length(move_buffer)-1
                        result[k] = -1
                    end
                    move_buffer = Vector{Int}()
                    break
                end
            end
            move_buffer = Vector{Int}()
        end

        # # TODO: this is a mess, needs to be refactored
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