import re
from functools import partial


def rm_ws(s):
    s = re.sub(r"\.", "", s)
    return s.strip(" ")


def rm_bag(s):
    s = re.sub("bag[s]?", "", s)
    return s.strip(" ")


def parse_values(vals):
    parsed = []
    for val in vals:
        num_bags, color = val[:2], val[2:]
        if num_bags == "no":
            num_bags = 0
            color = None
        else:
            num_bags = int(num_bags)
        parsed.append(tuple([num_bags, color]))
    return parsed


def parse(contents):
    lines = contents.split("\n")
    lines = [line for line in lines if len(line) > 0]
    parsed = [line.split("contain") for line in lines]
    parsed = [(rm_ws(container), list(rm_ws(s) for s in contained.split(",")))
              for container, contained in parsed]
    parsed = [(rm_bag(container), list(rm_bag(s) for s in contained))
              for container, contained in parsed]
    parsed = {c: parse_values(d) for c, d in parsed}
    return parsed


def can_contain(rules, container):
    return "shiny gold" in rules[container] or any(map(can_contain(rules, container)))


def solve_one(rules):
    can_contain_with_these_rules = partial(can_contain, rules)
    return sum(map(can_contain_with_these_rules, rules))


if __name__ == '__main__':
    with open("day07.txt", "r") as infile:
        contents = infile.read()
    rules = parse(contents)
    one = solve_one(rules)
    print("Puzzle #1: {}".format(one))
