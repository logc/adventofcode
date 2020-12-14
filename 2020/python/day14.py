from copy import copy
from itertools import product


def parse_bitmask(val):
    bitmask = []
    for char in val:
        if char == "X":
            bitmask.append(None)
        if char == "1":
            bitmask.append(1)
        if char == "0":
            bitmask.append(0)
    return bitmask


def parse_memory(val):
    a, b = val.index("["), val.index("]")
    addr = int(val[a+1:b])
    return "mem", addr


def parse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    action_values = [line.split("=") for line in lines]
    action_values = [(a.strip(), v.strip()) for a, v in action_values]
    program = []
    for act, val in action_values:
        if act.startswith("mask"):
            bitmask = parse_bitmask(val)
            program.append((act, bitmask))
        if act.startswith("mem"):
            val = int(val)
            mem, addr = parse_memory(act)
            program.append((mem, addr, val))
    return program


def dec_to_bin(n):
    binary = []
    while n >= 1:
        n, d = divmod(n, 2)
        binary.append(d)
    while len(binary) < 36:
        binary.append(0)
    return list(reversed(binary))


def apply_bitmask(bitmask, nbin):
    merged = []
    for mbit, nbit in zip(bitmask, nbin):
        if mbit is not None:
            merged.append(mbit)
        else:
            merged.append(nbit)
    return merged


def bin_to_dec(n):
    acc = 0
    length = len(n)
    for pos, bit in enumerate(n):
        if bit == 1:
            acc += pow(2, (length - pos - 1))
    return acc


def solve_one(program):
    memory = {}
    current_mask = None
    for instruction in program:
        if instruction[0] == "mask":
            current_mask = instruction[1]
        if instruction[0] == "mem":
            _, addr, val = instruction
            nbin = dec_to_bin(val)
            nbin = apply_bitmask(current_mask, nbin)
            n = bin_to_dec(nbin)
            memory[addr] = n
    return sum(memory.values())


def solve_two(program):
    memory = {}
    current_mask = None
    for instruction in program:
        if instruction[0] == "mask":
            current_mask = instruction[1]
        if instruction[0] == "mem":
            _, addr, val = instruction
            addrbin = dec_to_bin(addr)
            addresses = apply_bitmask_floating(current_mask, addrbin)
            for address in addresses:
                addrdec = bin_to_dec(address)
                memory[addrdec] = val
    return sum(memory.values())


def indexes(alist, elem):
    return [idx for idx, val in enumerate(alist) if val == elem]


def apply_bitmask_floating(bitmask, nbin):
    """bitmask, nbin -> [nbin]"""
    applied = []
    for mbit, nbit in zip(bitmask, nbin):
        if mbit == 0:
            applied.append(nbit)
        if mbit == 1:
            applied.append(1)
        if mbit is None:
            applied.append(None)
    floats = applied.count(None)
    none_idxs = indexes(applied, None)
    addresses = [copy(applied) for _ in range(2 ** floats)]
    for num, combination in enumerate(product([0, 1], repeat=floats)):
        for pos, bit in enumerate(combination):
            idx = none_idxs[pos]
            addresses[num][idx] = bit
    return addresses


if __name__ == '__main__':
    with open("day14.txt", "r") as infile:
        puzzle_input = infile.read()
    program = parse(puzzle_input)
    one = solve_one(program)
    two = solve_two(program)
    print(f"Puzzle #1 {one}")
    print(f"Puzzle #2 {two}")
