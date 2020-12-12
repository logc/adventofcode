from itertools import combinations


def parse(text):
    lines = [int(line) for line in text.split("\n") if len(line) > 0]
    return lines


def checks(numbers, index, window):
    n = numbers[index]
    previous = numbers[index - window:index]
    sums = [a + b for a, b in combinations(previous, 2)]
    return n in sums


def solve_one(numbers, window):
    for index in range(window, len(numbers)):
        if not checks(numbers, index, window):
            return numbers[index]


def does_sum_and_end(numbers, target, start):
    index = start
    acc = numbers[index]
    while acc < target:
        index += 1
        acc += numbers[index]
        if acc == target:
            return True, index
    return False, index


def solve_two(numbers, solution_one):
    for start in range(len(numbers)):
        does_sum, end = does_sum_and_end(numbers, solution_one, start)
        if does_sum:
            contiguous = numbers[start:end + 1]
            return max(contiguous) + min(contiguous)


if __name__ == '__main__':
    with open("day09.txt", "r") as infile:
        puzzle_input = infile.read()
    numbers = parse(puzzle_input)
    window = 25
    one = solve_one(numbers, window)
    two = solve_two(numbers, one)
    print("Puzzle #1: {}".format(one))
    print("Puzzle #2: {}".format(two))
