using BenchmarkTools

test_input = parse.(Int64, readlines("1/input.txt"));

function sum2(input, sum2val, is_sorted=false)
    sorted_exp = !is_sorted ? sort(input) : input;

    itr_exp = sorted_exp[sorted_exp .< sum2val / 2];
    chk_exp = sorted_exp[sum2val / 2 .<= sorted_exp .< sum2val]
    for expense in itr_exp
        matches = searchsorted(chk_exp, sum2val - expense)
        if matches.start <= matches.stop
            return expense * (sum2val - expense)
        end
    end
    return 0
end

function sum3(input, sum3val, is_sorted=false)
    sorted_exp = !is_sorted ? sort(input) : input;

    for expense in sorted_exp
        prod23 = sum2(sorted_exp[sorted_exp .> expense], sum3val - expense, true);
        if prod23 != 0
            return expense * prod23;
        end
    end
    return 0
end

# println("Part 1: $(sum2(test_input, 2020))")
# println("Part 2: $(sum3(test_input, 2020))")

@benchmark sum2(test_input, 2020)
@benchmark sum3(test_input, 2020)