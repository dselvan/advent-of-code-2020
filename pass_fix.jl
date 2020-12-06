line_regex = r"(\d+)-(\d+) ([a-z]): ([a-z]+)";
lines = readlines("2/input.txt");

function part1(input)
    function check_pw(item)
        return parse(Int64, item[1]) <= count(x -> (x == only(item[3])), item[4]) <= parse(Int64, item[2])
    end

    return count(check_pw.(map(x -> x.captures, match.(line_regex, lines))));
end

function part2(input)
    function check_pw(item)
        return (item[4][parse(Int64, item[1])] == only(item[3])) ⊻ (item[4][parse(Int64, item[2])] == only(item[3])) 
    end

    return count(check_pw.(map(x -> x.captures, match.(line_regex, lines))));
end


println("Part 1: $(part1(lines))")
println("Part 2: $(part2(lines))")
