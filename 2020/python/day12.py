def parse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    action_value = []
    for line in lines:
        action, value = line[0], line[1:]
        value = int(value)
        action_value.append((action, value))
    return action_value


def execute(instructions):
    position = 0 + 0j
    facing = 1 + 0j
    for action, value in instructions:
        if action == 'N':
            position += (0 + 1j) * value
        if action == 'S':
            position += (0 - 1j) * value
        if action == 'E':
            position += (1 + 0j) * value
        if action == 'W':
            position += (-1 + 0j) * value
        if action == 'L':
            for _ in range(value // 90):
                facing *= (0 + 1j)
        if action == 'R':
            for _ in range(value // 90):
                facing *= (0 - 1j)
        if action == 'F':
            position = position + facing * value
    return position


def solve_one(instructions):
    final = execute(instructions)
    return abs(final.real) + abs(final.imag)


def new_execute(instructions):
    position = 0 + 0j
    facing = 1 + 0j
    waypoint = position + (10 + 1j)
    for action, value in instructions:
        # print(f"Action: {action}, Value: {value}")
        if action == 'N':
            waypoint += (0 + 1j) * value
        if action == 'S':
            waypoint += (0 - 1j) * value
        if action == 'E':
            waypoint += (1 + 0j) * value
        if action == 'W':
            waypoint += (-1 + 0j) * value
        if action == 'L':
            relative_waypoint = waypoint - position
            for _ in range(value // 90):
                relative_waypoint *= (0 + 1j)
            waypoint = position + relative_waypoint
        if action == 'R':
            relative_waypoint = waypoint - position
            for _ in range(value // 90):
                relative_waypoint *= (0 - 1j)
            waypoint = position + relative_waypoint
        if action == 'F':
            relative_waypoint = waypoint - position
            waypoint += relative_waypoint * value
            position += relative_waypoint * value
        # print(f"Position: {position.real}, {position.imag}")
        # print(f"Waypoint: {waypoint.real}, {waypoint.imag}")
        # print("----")
    return position


def solve_two(instructions):
    final = new_execute(instructions)
    return abs(final.real) + abs(final.imag)


if __name__ == '__main__':
    with open("day12.txt", "r") as infile:
        puzzle_input = infile.read()
    instructions = parse(puzzle_input)
    one = solve_one(instructions)
    two = solve_two(instructions)
    print("Puzzle #1: {}".format(one))
    print("Puzzle #2: {}".format(two))
