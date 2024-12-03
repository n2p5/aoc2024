
function sumfromstring(s::String)
    re = r"mul\((\d{1,3}),(\d{1,3})\)"
    matches = eachmatch(re, s)
    sum = 0
    for m in matches
        x = parse(Int, m.captures[1])
        y = parse(Int, m.captures[2])
        sum += x * y
    end
    return sum
end

function removematches(s::String, re::Regex)
    matches = eachmatch(re, s)
    for m in matches
        s = replace(s, m.match => "")
    end
    return s
end

function main()
    input_file = joinpath(@__DIR__, "input.txt")
    file_content = replace(read(input_file, String), "\n" => "")
    # remove all matches of the pattern "don't().*do()"
    file_content = removematches(file_content, r"(don't\(\).*?do\(\)?)")
    # remove all matches of the pattern "don't()" to EOF
    file_content = removematches(file_content, r"(don\'t\(\).*)")
    sum = sumfromstring(file_content)
    println("sum: ", sum)
end


main()