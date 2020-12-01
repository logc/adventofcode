def solve_one(numbers, total):
    seen = set()
    for n in numbers:
        diff = total - n
        if diff in seen:
            return diff * n
        else:
            seen.add(n)


def solve_two(numbers):
    for pos, n in enumerate(numbers):
        rest = numbers[pos:]
        total = 2020 - n
        partial = solve_one(rest, total)
        if partial is not None:
            return partial * n


if __name__ == '__main__':
    with open("day01.txt", "r") as infile:
        puzzle_input = [int(line.strip()) for line in infile]
    one = solve_one(puzzle_input, 2020)
    two = solve_two(puzzle_input)
    print("Puzzle #1: {}".format(one))
    print("Puzzle #2: {}".format(two))
