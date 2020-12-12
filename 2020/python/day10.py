from math import factorial as fac
from operator import mul
from functools import reduce
from itertools import tee, combinations


def parse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    joltages = [int(line) for line in lines]
    return joltages


def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)


def pair_diffs(joltages):
    return [b - a for a, b in pairwise(sorted(joltages))]


def ones_and_threes(joltages):
    diffs = pair_diffs(joltages)
    ones = [d for d in diffs if d == 1]
    threes = [d for d in diffs if d == 3]
    return ones, threes


def solve_one(joltages):
    ones, threes = ones_and_threes(joltages)
    return (len(ones) + 1) * (len(threes) + 1)


def find_ones_range_lens(diffs):
    ones_lens = []
    n_ones = 0
    for diff in diffs:
        if diff == 1:
            n_ones += 1
        if diff == 3:
            ones_lens.append(n_ones)
            n_ones = 0
    return [o for o in ones_lens if o > 0]


def n_combinations(n, r):
    return fac(n) // (fac(r) * fac(n - r))


def total_combinations(ones_lens):
    total = []
    for ol in ones_lens:
        if ol > 1:
            C = n_combinations(ol, 2)
            total.append(ol + C)
    return total


def solve_two(parsed):
    diffs = pair_diffs(parsed)
    ones_lens = find_ones_range_lens(diffs)
    T = total_combinations(ones_lens)
    return T


if __name__ == '__main__':
    with open("day10.txt", "r") as infile:
        puzzle_input = infile.read()
    parsed = parse(puzzle_input)
    one = solve_one(parsed)
    two = solve_two(parsed)
    print("Puzzle #1: {}".format(one))
    print("Puzzle #2: {}".format(two))
