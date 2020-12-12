
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
    print(f"occupying seat at {pos}")
    layout[y][x] = True


def is_floor(pos, layout):
    x, y = pos
    return layout[y][x] is None


def free(pos, layout):
    x, y = pos
    print(f"freeing seat at {pos}")
    layout[y][x] = False


def first_rule(pos, layout):
    if (not is_floor(pos, layout) and not occupied(pos, layout)
            and no_adjacent_occupied(pos, layout)):
        occupy(pos, layout)
        return 1
    return 0


def second_rule(pos, layout):
    if (not is_floor(pos, layout) and occupied(pos, layout)
            and four_adjacent_occupied(pos, layout)):
        free(pos, layout)
        return 1
    return 0


def apply_rules(layout):
    changes = 0
    for y in range(len(layout)):
        for x in range(len(layout[0])):
            pos = x, y
            changes += first_rule(pos, layout)
            changes += second_rule(pos, layout)
    return changes


if __name__ == '__main__':
    with open("day11.txt", "r") as infile:
        puzzle_input = infile.read()
    layout = parse(puzzle_input)
