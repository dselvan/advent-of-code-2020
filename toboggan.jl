using BenchmarkTools

lines = readlines("3/input.txt");

function find_trees(input, right, down)
    grid = map(==('#'), hcat(collect.(input)...))';
    nrows, row_length = size(grid);
    
    # fold (reduce) function (result, element)
    # init res = (pos = 1, sum = 0)
    function fld_fnc((pos, sum), row_idx)
        # return our next pos and current sum
        return (mod1(pos + right, row_length), sum + grid[row_idx, pos])
    end
    
    # fold over each row, skip by down amount
    return foldl(fld_fnc, 1:down:nrows, init=(1, 0))[2]
end

function part1(input)
    return find_trees(input, 3, 1);
end

function part2(input)
    slopes = [
        (1, 1)
        (3, 1)
        (5, 1)
        (7, 1)
        (1, 2)
    ]
    return prod(map(x -> find_trees(input, x[1], x[2]), slopes))
end    

println("Part 1: $(part1(lines))");
println("Part 2: $(part2(lines))");

@benchmark part2(lines)
