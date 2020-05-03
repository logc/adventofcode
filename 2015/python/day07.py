#!/usr/bin/env python

# --- Day 7: Some Assembly Required ---
#
# This year, Santa brought little Bobby Tables a set of wires and bitwise logic
# gates! Unfortunately, little Bobby is a little under the recommended age
# range, and he needs help assembling the circuit.
#
# Each wire has an identifier (some lowercase letters) and can carry a 16-bit
# signal (a number from 0 to 65535). A signal is provided to each wire by a
# gate, another wire, or some specific value. Each wire can only get a signal
# from one source, but can provide its signal to multiple destinations. A gate
# provides no signal until all of its inputs have a signal.
#
# The included instructions booklet describes how to connect the parts
# together: x AND y -> z means to connect wires x and y to an AND gate, and
# then connect its output to wire z.
#
# For example:
#
# -   123 -> x means that the signal 123 is provided to wire x.
#
# -   x AND y -> z means that the bitwise AND of wire x and wire y is provided
#     to wire z.
#
# -   p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and
#     then provided to wire q.
#
# -   NOT e -> f means that the bitwise complement of the value from wire e is
#     provided to wire f.
#
# Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If,
# for some reason, you'd like to emulate the circuit instead, almost all
# programming languages (for example, C, JavaScript, or Python) provide operators
# for these gates.
#
# For example, here is a simple circuit:
#
# 123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i
#
# After it is run, these are the signals on the wires:
#
# d: 72
# e: 507
# f: 492
# g: 114
# h: 65412
# i: 65079
# x: 123
# y: 456
#
# In little Bobby's kit's instructions booklet (provided as your puzzle input),
# what signal is ultimately provided to wire a?
import numpy as np


class Circuit:

    def __init__(self):
        self.circuit = {}

    def process(self, line):
        instructions, wire_name = [s.strip() for s in line.split("->")]
        if instructions.isdigit():
            self.circuit[wire_name] = wire_of_value(int(instructions))
        if "AND" in instructions:
            a_wire, b_wire = self.get_two_wires(tokenize(instructions))
            self.circuit[wire_name] = np.logical_and(a_wire, b_wire)
        if "OR" in instructions:
            a_wire, b_wire = self.get_two_wires(tokenize(instructions))
            self.circuit[wire_name] = np.logical_or(a_wire, b_wire)
        if "NOT" in instructions:
            a_wire = self.get_wire(tokenize(instructions))
            self.circuit[wire_name] = np.logical_not(a_wire)
        if "LSHIFT" in instructions:
            a_wire, amount = self.get_wire_amount(tokenize(instructions))
            self.circuit[wire_name] = shift(a_wire, -1 * amount)
        if "RSHIFT" in instructions:
            a_wire, amount = self.get_wire_amount(tokenize(instructions))
            self.circuit[wire_name] = shift(a_wire, amount)

    def get_two_wires(self, tokens):
        a_wire_name, _, b_wire_name = tokens
        return self.circuit[a_wire_name], self.circuit[b_wire_name]

    def get_wire(self, tokens):
        _, a_wire_name = tokens
        return self.circuit[a_wire_name]

    def get_wire_amount(self, tokens):
        a_wire_name, _, amount = tokens
        return self.circuit[a_wire_name], int(amount)

    def value_of(self, wire_name):
        return value_of_wire(self.circuit[wire_name])


def wire_of_value(value):
    return np.array([bool(int(digit)) for digit in format(value, '0>16b')])


def value_of_wire(wire):
    return sum(int(bit) * 2 ** exp for exp, bit in enumerate(reversed(wire)))


def tokenize(instructions):
    return [s.strip() for s in instructions.split()]


def shift(arr, num, fill_value=False):
    result = np.empty_like(arr)
    if num > 0:
        result[:num] = fill_value
        result[num:] = arr[:-num]
    elif num < 0:
        result[num:] = fill_value
        result[:num] = arr[-num:]
    else:
        result[:] = arr
    return result

INSTRUCTIONS = [
    "x AND y -> d",
    "123 -> x",
    "456 -> y",
    "x OR y -> e",
    "x LSHIFT 2 -> f",
    "y RSHIFT 2 -> g",
    "NOT x -> h",
    "NOT y -> i"
]

if __name__ == "__main__":
    with open("day07.txt", "r") as infile:
        MY_INPUT = infile.readlines()
    circuit = Circuit()
    for lineno, input_line in enumerate(MY_INPUT):
        try:
            circuit.process(input_line)
        except KeyError as err:
            print(lineno)
            raise err
    print(circuit.value_of('a'))
