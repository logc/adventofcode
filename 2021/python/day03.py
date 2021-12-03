from copy import copy


def parse(line):
    return [int(c) for c in line.strip()]


def solve(lines):
    most, least = find_freqs(lines)
    return list_to_bin(most) * list_to_bin(least)


def find_freqs(lines):
    bit_num = len(lines[0])
    bit_freqs = [[0, 0] for _ in range(bit_num)]
    for line in lines:
        for pos, bit in enumerate(line):
            bit_freqs[pos][bit] += 1
    most = [0 if f0 > f1 else 1 for f0, f1 in bit_freqs]
    least = [0 if f0 < f1 else 1 for f0, f1 in bit_freqs]
    return most, least


def list_to_bin(a_list):
    return int("".join(str(x) for x in a_list), 2)


def solve2(lines):
    ogr = find_ogr(lines)
    scr = find_scr(lines)
    return list_to_bin(ogr) * list_to_bin(scr)


def find_ogr(lines, pos=0):
    if len(lines) == 1:
        return lines[0]
    freqs = [0, 0]
    for line in lines:
        freqs[line[pos]] += 1
    if freqs[0] > freqs[1]:
        sought = 0
    if freqs[1] > freqs[0]:
        sought = 1
    if freqs[0] == freqs[1]:
        sought = 1
    next_lines = [line for line in lines if line[pos] == sought]
    next_pos = pos + 1
    return find_ogr(next_lines, next_pos)


def find_scr(lines, pos=0):
    if len(lines) == 1:
        return lines[0]
    freqs = [0, 0]
    for line in lines:
        freqs[line[pos]] += 1
    sought = 0
    if freqs[0] < freqs[1]:
        sought = 0
    if freqs[1] < freqs[0]:
        sought = 1
    if freqs[0] == freqs[1]:
        sought = 0
    next_lines = [line for line in lines if line[pos] == sought]
    next_pos = pos + 1
    return find_scr(next_lines, next_pos)


if __name__ == '__main__':
    with open("day03.txt", "r") as infile:
        lines = [parse(line) for line in infile]
    print(solve(lines))
    print(solve2(lines))
