def parse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    parsed = []
    for line in lines:
        opcode, amount = line.split(" ")
        amount = int(amount)
        parsed.append((opcode, amount))
    return parsed


def execute(instruction, index, acc):
    opcode, amount = instruction
    if opcode == 'acc':
        acc = acc + amount
        index += 1
    elif opcode == 'jmp':
        index = index + amount
    elif opcode == 'nop':
        index += 1
    return index, acc


def solve_one(instructions):
    index, acc = 0, 0
    seen = set()
    while index not in seen:
        seen.add(index)
        index, acc = execute(instructions[index], index, acc)
    return acc


def flip(instruction):
    opcode, amount = instruction
    if opcode == 'jmp':
        opcode = 'nop'
    elif opcode == 'nop':
        opcode = 'jmp'
    return opcode, amount


def change(program, index):
    new_program = []
    new_instruction = flip(program[index])
    for pos, instruction in enumerate(program):
        if pos == index:
            new_program.append(new_instruction)
        else:
            new_program.append(instruction)
    return new_program


def does_terminate_and_acc(program):
    index, acc = 0, 0
    seen = set()
    while index < len(program):
        seen.add(index)
        index, acc = execute(program[index], index, acc)
        if index in seen:
            return False, acc
    return True, acc


def solve_two(instructions):
    for index in reversed(range(len(instructions))):
        program = change(instructions, index)
        does_terminate, acc = does_terminate_and_acc(program)
        if does_terminate:
            return acc


if __name__ == '__main__':
    with open("day08.txt", "r") as infile:
        puzzle_input = infile.read()
    instructions = parse(puzzle_input)
    one = solve_one(instructions)
    two = solve_two(instructions)
    print("Puzzle #1: {}".format(one))
    print("Puzzle #2: {}".format(two))
