from operator import mul, add
from types import BuiltinFunctionType


class Node:
    def __init__(self, data):
        self.left = None
        self.right = None
        self.data = data

    def insert(self, data):
        if self.left is None:
            self.left = Node(data)
        elif self.right is None:
            self.right = Node(data)
        else:
            self.right.insert(data)

    def print(self):
        if self.left:
            self.left.print()
        print(self.data)
        if self.right:
            self.right.print()

    def eval(self):
        if isinstance(self.data, int):
            return self.data
        if isinstance(self.data, BuiltinFunctionType):
            return self.data(self.left.eval(), self.right.eval())


def parse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    parsed = [parse_line(line) for line in lines]
    return parsed


def parse_line(line):
    tokens = line.split()
    nodes = []
    for token in tokens:
        if token.isdigit():
            node = int(token)
        if token == '+':
            node = add
        if token == '*':
            node = mul
        nodes.append(node)
    return nodes


def solve_one(parsed):
    return len(parsed)


if __name__ == '__main__':
    with open("day18.txt", "r") as infile:
        puzzle_input = infile.read()
    parsed = parse(puzzle_input)
    one = solve_one(parsed)
    print(f"Puzzle #1: {one}")
