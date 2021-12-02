from itertools import tee

def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)

def triplewise(iterable):
    a, b, c = tee(iterable, 3)
    next(b, None)
    next(c, None)
    next(c, None)
    return zip(a, b, c)

with open("day01.txt") as infile:
    depths = [int(line.strip()) for line in infile]
    diffs = [d2 - d1 for d1, d2 in pairwise(depths)]
    increased = [(diff > 0) for diff in diffs]
    print(sum(increased))
    measurements = [sum([a, b, c]) for a, b, c in triplewise(depths)]
    measured_diffs = [d2 - d1 for d1, d2 in pairwise(measurements)]
    increases = [(diff > 0) for diff in measured_diffs]
    print(sum(increases))
