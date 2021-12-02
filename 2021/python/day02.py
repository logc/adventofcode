def parse(line):
    move, times = line.strip().split()
    times = int(times)
    if move == "forward":
        move = 0
    elif move == "down":
        move = 1
    elif move == "up":
        move = 1
        times = -1 * times
    return move, times


def update_pos(pos, move):
    coord, units = move
    pos[coord] += units
    return pos


def parse2(line):
    move, times = line.strip().split()
    times = int(times)
    return move, times


def update_pos2(pos, move):
    move, units = move
    if move == "down":
        pos[2] += units
    if move == "up":
        pos[2] -= units
    if move == "forward":
        pos[0] += units
        pos[1] += pos[2] * units
    return pos


if __name__ == '__main__':
    with open("day02.txt", "r") as infile:
        moves = [parse(line) for line in infile]
    pos = [0, 0]
    for move in moves:
        pos = update_pos(pos, move)
    print(pos[0] * pos[1])

    with open("day02.txt", "r") as infile:
        moves2 = [parse2(line) for line in infile]
    pos2 = [0, 0, 0]
    for move2 in moves2:
        pos2 = update_pos2(pos2, move2)
    print(pos2[0] * pos2[1])
