#!/usr/bin/env python3
"""
Solves day 3 puzzles from Advent of Code.
"""

# Santa is delivering presents to an infinite two-dimensional grid of houses.

# He begins by delivering a present to the house at his starting location, and
# then an elf at the North Pole calls him via radio and tells him where to move
# next. Moves are always exactly one house to the north (^), south (v), east
# (>), or west (<). After each move, he delivers another present to the house
# at his new location.

# However, the elf back at the north pole has had a little too much eggnog, and
# so his directions are a little off, and Santa ends up visiting some houses
# more than once. How many houses receive at least one present?

# For example:

# - > delivers presents to 2 houses: one at the starting location, and one to
#   the east.

# - ^>v< delivers presents to 4 houses in a square, including twice to the
#   house at his starting/ending location.

# - ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only
#   2 houses.


def update_position(current, update):
    """
    Returns an updated position for Santa.
    """
    new = current
    if update == ">":
        new = (current[0] + 1, current[1])
    if update == "<":
        new = (current[0] - 1, current[1])
    if update == "^":
        new = (current[0], current[1] + 1)
    if update == "v":
        new = (current[0], current[1] - 1)
    return new


def record_positions(updates):
    """
    Moves Santa around the grid following the updates, and records each
    position where Santa has been. Returns all positions.
    """
    current = (0, 0)
    positions = [current]
    for update in updates:
        current = update_position(current, update)
        positions.append(current)
    return positions


def unique_positions(updates):
    """
    Returns how many unique positions were found following the updates.
    """
    return unique(record_positions(updates))


def unique(something):
    """
    Returns how many unique things were in something.
    """
    return len(set(something))

# The next year, to speed up the process, Santa creates a robot version of
# himself, Robo-Santa, to deliver presents with him.

# Santa and Robo-Santa start at the same location (delivering two presents to
# the same starting house), then take turns moving based on instructions from
# the elf, who is eggnoggedly reading from the same script as the previous
# year.

# This year, how many houses receive at least one present?

# For example:

# - ^v delivers presents to 3 houses, because Santa goes north, and then
#   Robo-Santa goes south.
# - ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end
#   up back where they started.
# - ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one
#   direction and Robo-Santa going the other.


def record_both_positions(updates):
    """
    Moves Santa and Robo-Santa around the grid following the updates, and
    records each position where they have been. Returns all positions.
    """
    santa = (0, 0)
    robos = (0, 0)
    positions = [santa, robos]
    for turn, update in enumerate(updates):
        if turn % 2 == 0:
            santa = update_position(santa, update)
            positions.append(santa)
        else:
            robos = update_position(robos, update)
            positions.append(robos)
    return positions


def unique_both_positions(updates):
    """
    Returns how many unique positions were found following the updates
    by both Santa and Robo-Santa.
    """
    return unique(record_both_positions(updates))


if __name__ == "__main__":
    with open("day03.txt", "r") as infile:
        CONTENTS = infile.read()
    print(unique_positions(CONTENTS))
    print(unique_both_positions(CONTENTS))
