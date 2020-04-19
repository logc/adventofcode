#!/usr/bin/env python
"""
Solves puzzles from day 5 of Advent of Code 2015.
"""

# Santa needs help figuring out which strings in his text file are naughty or
# nice.

# A nice string is one with all of the following properties:

#  - It contains at least three vowels (aeiou only), like aei, xazegov, or
#    aeiouaeiouaeiou.
#  - It contains at least one letter that appears twice in a row, like xx,
#    abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
#  - It does not contain the strings ab, cd, pq, or xy, even if they are part
#    of one of the other requirements.

# For example:

#  - ugknbfddgicrmopn is nice because it has at least three vowels
#    (u...i...o...), a double letter (...dd...), and none of the disallowed
#    substrings.
#  - aaa is nice because it has at least three vowels and a double letter,
#    even though the letters used by different rules overlap.
#  - jchzalrnumimnmhp is naughty because it has no double letter.
#  - haegwjzuvuyypxyu is naughty because it contains the string xy.
#  - dvszwmarrgswjxmb is naughty because it contains only one vowel.

# How many strings are nice?
from itertools import tee


def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    first, second = tee(iterable)
    next(second, None)
    return zip(first, second)


def has_three_vowels(string):
    "Returns True if string has three vowels."
    vowels = 0
    for char in string:
        if char in "aeiou":
            vowels += 1
    return vowels >= 3


def has_repeated_letter(string):
    "Returns True if at least one letter is repeated in string."
    repeated = False
    for prev, nxt in pairwise(string):
        if prev == nxt:
            repeated = True
    return repeated


def contains_forbidden(string):
    "Returns True if string cotains one forbidden combination."
    return ("ab" in string or
            "cd" in string or
            "pq" in string or
            "xy" in string)


def is_nice(string):
    "Returns True if a string is nice."
    return (has_three_vowels(string) and
            has_repeated_letter(string) and
            not contains_forbidden(string))

# Realizing the error of his ways, Santa has switched to a better model of
# determining whether a string is naughty or nice. None of the old rules apply,
# as they are all clearly ridiculous.

# Now, a nice string is one with all of the following properties:

# - It contains a pair of any two letters that appears at least twice in the
#   string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like
#   aaa (aa, but it overlaps).
# - It contains at least one letter which repeats with exactly one letter
#   between them, like xyx, abcdefeghi (efe), or even aaa.

# For example:

# - qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and
#   a letter that repeats with exactly one letter between them (zxz).
# - xxyxx is nice because it has a pair that appears twice and a letter that
#   repeats with one between, even though the letters used by each rule overlap
# - uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a
#   single letter between them.
# - ieodomkazucvgmuy is naughty because it has a repeating letter with one
#   between (odo), but no pair that appears twice.

# How many strings are nice under these new rules?


def contains_pair_twice_no_overlap(string):
    "Returns True if a pair of letters is repeated without overlapping."
    twice = False
    overlap = True
    for one_start, one_pair in enumerate(pairwise(string)):
        for other_start, other_pair in enumerate(pairwise(string)):
            if one_pair == other_pair:
                twice = True
                if abs(one_start - other_start) > 1:
                    overlap = False
    return twice and not overlap


def triplewise(iterable):
    "Returns triples of characters from a string."
    first = iter(iterable)
    second = iter(iterable)
    third = iter(iterable)
    next(second, None)
    # Advance twice the second pointer
    next(third, None)
    next(third, None)
    return zip(first, second, third)


def contains_repeated_at_distance_one(string):
    "Returns True if there is one repeated letter with one letter in between."
    repeated = False
    for a_char, _, b_char in triplewise(string):
        if a_char == b_char:
            repeated = True
    return repeated


def new_is_nice(string):
    "Returns True if a string is nice following the new rules."
    return (contains_pair_twice_no_overlap(string) and
            contains_repeated_at_distance_one(string))


if __name__ == "__main__":
    with open("day05.txt", "r") as infile:
        MY_INPUT = infile.readlines()
    NICE_COUNT = 0
    NEW_NICE_COUNT = 0
    for line in MY_INPUT:
        if is_nice(line):
            NICE_COUNT += 1
        if new_is_nice(line):
            NEW_NICE_COUNT += 1
    print(NICE_COUNT)
    print(NEW_NICE_COUNT)
