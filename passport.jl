using BenchmarkTools

lines = replace.(split(open(f -> read(f, String), "4/input.txt"), "\n\n"), "\n" => " ");

required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];

function convert_line_to_record(line)
    parse = reduce(hcat, split.(string.(split(rstrip(line), " ")), ":"));
    return [parse[1,:] parse[2,:]]
end

function validate_required_fields(field_list, required_fields)
    return isempty(setdiff(required_fields, field_list)) ? 1 : 0
end

function validate_byr(value)
    return length(value) == 4 && (1920 <= parse(Int, value) <= 2002);
end

function validate_iyr(value)
    return length(value) == 4 && (2010 <= parse(Int, value) <= 2020);
end

function validate_eyr(value)
    return length(value) == 4 && (2020 <= parse(Int, value) <= 2030);
end

function validate_hgt(value)
    if value[end - 1:end] == "cm"
        return 150 <= parse(Int, value[1:end - 2]) <= 193
    elseif value[end - 1:end] == "in"
        return 59 <= parse(Int, value[1:end - 2]) <= 76
    else
        return false;
    end
end

function validate_hcl(value)
    return match(r"#[a-fA-F\d]{6}", value) !== nothing;
end

function validate_ecl(value)
    return value in ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"];    
end

function validate_pid(value)
    return length(value) == 9 && tryparse(Int, value) !== nothing;
end

function validate_passport(record)
    if validate_required_fields(record[:,1], required_fields) == 1
        for (item, value) in zip(record[:,1], record[:,2])
            if item == "byr"
                if !validate_byr(value)
                    return 0
                end
            elseif item == "iyr"
                if !validate_iyr(value)
                    return 0
                end
            elseif item == "eyr"
                if !validate_eyr(value)
                    return 0
                end
            elseif item == "hgt"
                if !validate_hgt(value)
                    return 0
                end
            elseif item == "hcl"
                if !validate_hcl(value)
                    return 0
                end
            elseif item == "ecl"
                if !validate_ecl(value)
                    return 0
                end
            elseif item == "pid"
                if !validate_pid(value)
                    return 0
                end
            end                      
        end
        return 1  
    else
        return 0
    end    
end

function part1(input)
    count = 0;
    for line in input
        field_list = convert_line_to_record(line)[:,1];
        count += validate_required_fields(field_list, required_fields);
    end
    return count;
end

function part2(input)
    count = 0;
    for line in input
        record = convert_line_to_record(line); 
        count += validate_passport(record);
    end
    return count;
end

println("Part 1: $(part1(lines))");
println("Part 2: $(part2(lines))");

@benchmark part2(lines)

