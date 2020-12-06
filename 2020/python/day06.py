from itertools import groupby


def parse_contents(text):
    lines = text.split("\n")
    line_groups = [list(g) for k, g in groupby(
        lines, lambda line: len(line) == 0) if not k]
    answer_lines = [(set("".join(s for s in group)), group)
                    for group in line_groups]
    return answer_lines


def solve_one(lines):
    return sum(len(line) for line in lines)


def solve_two(lines):
    counts = []
    for uniq, answers in lines:
        count = 0
        for u in uniq:
            if all(u in a for a in answers):
                count += 1
        counts.append(count)
    return sum(counts)


if __name__ == '__main__':
    with open("day06.txt", "r") as infile:
        lines = parse_contents(infile.read())
    one = solve_one([s for s, _ in lines])
    two = solve_two(lines)
    print("Puzzle #1: {}".format(one))
    print("Puzzle #2: {}".format(two))
