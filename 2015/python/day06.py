#!/usr/bin/env python
"Solves puzzles from day 6, 2015"

# --- Day 6: Probably a Fire Hazard ---

# Because your neighbors keep defeating you in the holiday house decorating
# contest year after year, you've decided to deploy one million lights in a
# 1000x1000 grid.

# Furthermore, because you've been especially nice this year, Santa has mailed
# you instructions on how to display the ideal lighting configuration.

# Lights in your grid are numbered from 0 to 999 in each direction; the lights
# at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions
# include whether to turn on, turn off, or toggle various inclusive ranges
# given as coordinate pairs. Each coordinate pair represents opposite corners
# of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore
# refers to 9 lights in a 3x3 square. The lights all start turned off.

# To defeat your neighbors this year, all you have to do is set up your lights
# by doing the instructions Santa sent you in order.

# For example:

# - turn on 0,0 through 999,999 would turn on (or leave on) every light.

# - toggle 0,0 through 999,0 would toggle the first line of 1000 lights,
#   turning off the ones that were on, and turning on the ones that were off.

# - turn off 499,499 through 500,500 would turn off (or leave off) the middle
#   four lights.

# After following the instructions, how many lights are lit?
import numpy as np


class Lights:
    "Represents a grid of lights."

    def __init__(self, size):
        self.grid = np.full((size, size), False)

    def turn_on(self, lower_corner, upper_corner):
        "Turns on lights from lower left corner to upper right corner."
        lower_x, lower_y = lower_corner
        upper_x, upper_y = upper_corner
        self.grid[lower_x:(upper_x + 1), lower_y:(upper_y + 1)] = True

    def turn_off(self, lower_corner, upper_corner):
        "Turns off lights from lower left corner to upper right corner."
        lower_x, lower_y = lower_corner
        upper_x, upper_y = upper_corner
        self.grid[lower_x:(upper_x + 1), lower_y:(upper_y + 1)] = False

    def toggle(self, low_corner, high_corner):
        "Toggles lights on/off."
        low_x, low_y = low_corner
        high_x, high_y = high_corner
        # pylint: disable=invalid-name
        for x in range(low_x, high_x + 1):
            for y in range(low_y, high_y + 1):
                self.grid[x, y] = (not self.grid[x, y])
        # pylint: enable=invalid-name

    def process(self, instruction):
        "Process a single instruction by tuning on/off or toggling lights."
        code, lower_corner, upper_corner = instruction
        if code not in ["toggle", "turn on", "turn off"]:
            raise RuntimeError("unknown instruction: {}".format(instruction))
        if code == "toggle":
            self.toggle(lower_corner, upper_corner)
        elif code == "turn on":
            self.turn_on(lower_corner, upper_corner)
        elif code == "turn off":
            self.turn_off(lower_corner, upper_corner)

    def count_on(self):
        "Returns how many lights are turned on."
        return np.count_nonzero(self.grid)


def parse(line):
    "Parse a line of input into an instruction for the grid."
    tokens = line.rsplit(" ", 3)
    instruction, lower, _, upper = tokens
    lower_x, lower_y = [int(coord) for coord in lower.split(",")]
    upper_x, upper_y = [int(coord) for coord in upper.split(",")]
    lower_corner = (lower_x, lower_y)
    upper_corner = (upper_x, upper_y)
    return (instruction, lower_corner, upper_corner)


# --- Part Two ---

# You just finish implementing your winning light pattern when you realize you
# mistranslated Santa's message from Ancient Nordic Elvish.

# The light grid you bought actually has individual brightness controls; each
# light can have a brightness of zero or more. The lights all start at zero.

# The phrase turn on actually means that you should increase the brightness of
# those lights by 1.

# The phrase turn off actually means that you should decrease the brightness of
# those lights by 1, to a minimum of zero.

# The phrase toggle actually means that you should increase the brightness of
# those lights by 2.

# What is the total brightness of all lights combined after following Santa's
# instructions?

# For example:

# - turn on 0,0 through 0,0 would increase the total brightness by 1.
# - toggle 0,0 through 999,999 would increase the total brightness by 2000000.

class BrightLights:
    "Represents a grid of lights that have a discrete brightness."

    def __init__(self, size):
        self.grid = np.full((size, size), 0)

    def turn_on(self, lower_corner, upper_corner):
        "Increases brightness of lights from lower corner to upper corner."
        lower_x, lower_y = lower_corner
        upper_x, upper_y = upper_corner
        self.grid[lower_x:(upper_x + 1), lower_y:(upper_y + 1)] += 1

    def turn_off(self, lower_corner, upper_corner):
        "Decreases brightness of lights from lower corner to upper corner."
        lower_x, lower_y = lower_corner
        upper_x, upper_y = upper_corner
        # pylint: disable=invalid-name
        for x in range(lower_x, upper_x + 1):
            for y in range(lower_y, upper_y + 1):
                current = self.grid[x, y]
                self.grid[x, y] = max(current - 1, 0)
        # pylint: enable=invalid-name

    def toggle(self, lower_corner, upper_corner):
        "Increases brightness of lights by 2 steps."
        lower_x, lower_y = lower_corner
        upper_x, upper_y = upper_corner
        self.grid[lower_x:(upper_x + 1), lower_y:(upper_y + 1)] += 2

    def process(self, instruction):
        "Process a single instruction by increasing/decreasing brightness."
        code, lower_corner, upper_corner = instruction
        if code not in ["toggle", "turn on", "turn off"]:
            raise RuntimeError("unknown instruction: {}".format(instruction))
        if code == "toggle":
            self.toggle(lower_corner, upper_corner)
        elif code == "turn on":
            self.turn_on(lower_corner, upper_corner)
        elif code == "turn off":
            self.turn_off(lower_corner, upper_corner)

    def count_brightness(self):
        "Returns the total brightness of the grid."
        return np.sum(self.grid)


if __name__ == "__main__":
    with open("day06.txt", "r") as infile:
        MY_INPUT = infile.readlines()

    GRID = Lights(1000)
    BGRID = BrightLights(1000)
    for input_line in MY_INPUT:
        INSTRUCTION = parse(input_line)
        GRID.process(INSTRUCTION)
        BGRID.process(INSTRUCTION)
    print(GRID.count_on())
    print(BGRID.count_brightness())
