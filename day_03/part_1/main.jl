



function main()
    re = r"mul\((\d{1,3}),(\d{1,3})\)"
    input_file = joinpath(@__DIR__, "input.txt")
    file_content = read(input_file, String)
    matches = eachmatch(re, file_content)
    sum = 0
    for m in matches
        x = parse(Int, m.captures[1])
        y = parse(Int, m.captures[2])
        sum += x * y
    end
    println("sum: ", sum)
end


main()