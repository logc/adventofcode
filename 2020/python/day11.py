from copy import deepcopy


def parse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    layout = []
    for line in lines:
        seats = []
        for position in line:
            if position == "L":
                seats.append(False)
            if position == ".":
                seats.append(None)
            if position == "#":
                seats.append(True)
        layout.append(seats)
    return layout


def no_adjacent_occupied(pos, layout):
    max_x = len(layout[0])
    max_y = len(layout)
    return not any(occupied(adj, layout) for adj in adjacent(pos, max_x, max_y))


def four_adjacent_occupied(pos, layout):
    max_x = len(layout[0])
    max_y = len(layout)
    return sum(occupied(adj, layout) for adj in adjacent(pos, max_x, max_y)
               if not is_floor(adj, layout)) >= 4


def adjacent(pos, max_x, max_y):
    x, y = pos
    for i in [x - 1, x, x + 1]:
        for j in [y - 1, y, y + 1]:
            if (i, j) != (x, y) and i >= 0 and i < max_x and j >= 0 and j < max_y:
                yield (i, j)


def occupied(pos, layout):
    x, y = pos
    return layout[y][x]


def occupy(pos, layout):
    x, y = pos
    layout[y][x] = True


def is_floor(pos, layout):
    x, y = pos
    return layout[y][x] is None


def free(pos, layout):
    x, y = pos
    layout[y][x] = False


def first_rule(pos, layout):
    return (not is_floor(pos, layout) and not occupied(pos, layout)
            and no_adjacent_occupied(pos, layout))


def second_rule(pos, layout):
    return (not is_floor(pos, layout) and occupied(pos, layout)
            and four_adjacent_occupied(pos, layout))


def apply_rules(layout):
    new_layout = deepcopy(layout)
    changes = 0
    for y in range(len(layout)):
        for x in range(len(layout[0])):
            pos = x, y
            if first_rule(pos, layout):
                occupy(pos, new_layout)
                changes += 1
            if second_rule(pos, layout):
                free(pos, new_layout)
                changes += 1
    return changes, new_layout


def sum_occupied(layout):
    return sum(layout[y][x]
               for x in range(len(layout[0]))
               for y in range(len(layout))
               if layout[y][x] is not None)


def solve_one(layout):
    changes, layout = apply_rules(layout)
    while changes > 0:
        changes, layout = apply_rules(layout)
    return sum_occupied(layout)


def look_right(pos, layout):
    i, j = pos
    rows = len(layout[0])
    for x in range(i, rows):
        elem = layout[j][x]
        if elem is not None:
            return elem


def look_left(pos, layout):
    i, j = pos
    for x in range(i, 0, -1):
        elem = layout[j][x]
        if elem is not None:
            return elem


def look_up(pos, layout):
    i, j = pos
    for y in range(j, 0, -1):
        elem = layout[y][i]
        if elem is not None:
            return elem


def look_down(pos, layout):
    i, j = pos
    cols = len(layout)
    for y in range(j, cols):
        elem = layout[y][i]
        if elem is not None:
            return elem


def look_left_up(pos, layout):
    i, j = pos
    while i > 0 and j > 0:
        i -= 1
        j -= 1
        elem = layout[j][i]
        if elem is not None:
            return elem


def look_right_up(pos, layout):
    i, j = pos
    cols = len(layout)
    while i > 0 and j < cols:
        i -= 1
        j += 1
        elem = layout[j][i]
        if elem is not None:
            return elem


def look_left_down(pos, layout):
    i, j = pos
    rows = len(layout[0])
    while i < rows and j


if __name__ == '__main__':
    with open("day11.txt", "r") as infile:
        puzzle_input = infile.read()
    layout = parse(puzzle_input)
    one = solve_one(layout)
    print("Puzzle #1: {}".format(one))
