def solve_one(numbers):
    for m in numbers:
        for n in numbers:
            if m + n == 2020:
                return m * n


def solve_two(numbers):
    for m in numbers:
        for n in numbers:
            for i in numbers:
                if m + n + i == 2020:
                    return m * n * i


if __name__ == '__main__':
    with open("day01.txt", "r") as infile:
        puzzle_input = [int(line.strip()) for line in infile]
    one = solve_one(puzzle_input)
    two = solve_two(puzzle_input)
    assert one == 445536
    assert two == 138688160
    print("Puzzle #1: {}".format(solve_one(puzzle_input)))
    print("Puzzle #2: {}".format(solve_two(puzzle_input)))
