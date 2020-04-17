# Santa is trying to deliver presents in a large apartment building, but he
# can't find the right floor - the directions he got are a little confusing. He
# starts on the ground floor (floor 0) and then follows the instructions one
# character at a time.
#
# An opening parenthesis, (, means he should go up one floor, and a closing
# parenthesis, ), means he should go down one floor.
#
# The apartment building is very tall, and the basement is very deep; he will
# never find the top or bottom floors.
#
# For example:
#
#     (()) and ()() both result in floor 0.
#     ((( and (()(()( both result in floor 3.
#     ))((((( also results in floor 3.
#     ()) and ))( both result in floor -1 (the first basement level).
#     ))) and )())()) both result in floor -3.
#
# To what floor do the instructions take Santa?


def follow_instructions(instructions):
    """Follow all instructions and return in which floor Santa is."""
    floor = 0
    for token in instructions:
        if token == "(":
            floor += 1
        elif token == ")":
            floor -= 1
    return floor


def find_basement(instructions):
    """
    Follow instructions keeping record of how many of them there are, and stop
    whenever Santa is in a floor below the street level. Return how many
    instructions did we follow up to that point.
    """
    floor = 0
    ans = 1
    for pos, token in enumerate(instructions):
        if token == "(":
            floor += 1
        elif token == ")":
            floor -= 1
        if floor < 0:
            ans = pos + 1
            break
    return ans


if __name__ == "__main__":
    with open("day01.txt") as infile:
        CONTENTS = infile.read()

    print(follow_instructions(CONTENTS))
    print(find_basement(CONTENTS))
