def parse(line):
    line = line.strip()
    policy, password = line.split(":")
    password = password.strip()
    repeats, letter = policy.split()
    lowest, highest = [int(d) for d in repeats.split("-")]
    return ((lowest, highest, letter), password)


def is_valid(password, policy):
    lowest, highest, letter = policy
    actual = password.count(letter)
    return lowest <= actual <= highest


def solve_one(lines):
    valids = 0
    for policy, password in lines:
        if is_valid(password, policy):
            valids += 1
    return valids


def is_valid_new(password, policy):
    lowest, highest, letter = policy
    low_idx = lowest - 1
    high_idx = highest - 1
    return ((password[low_idx] == letter) != (password[high_idx] == letter))


def solve_two(lines):
    valids = 0
    for policy, password in lines:
        if is_valid_new(password, policy):
            valids += 1
    return valids


if __name__ == '__main__':
    with open("day02.txt", "r") as infile:
        lines = [parse(line) for line in infile]
    one = solve_one(lines)
    two = solve_two(lines)
    print("Puzzle #1: {}".format(one))
    print("Puzzle #2: {}".format(two))
