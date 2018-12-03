import re
from collections import defaultdict


class Claim(object):

    def __init__(self, string):
        matches = re.match(r"#(\d*)\s@\s(\d*),(\d*):\s(\d*)x(\d*)", string)
        self.claim_id = int(matches.group(1))
        self.left_pos = int(matches.group(2))
        self.top_pos = int(matches.group(3))
        self.wide = int(matches.group(4))
        self.tall = int(matches.group(5))

    @property
    def pixels(self):
        return self.to_pixels()

    def to_pixels(self):
        pixels = []
        for x in range(self.left_pos, self.left_pos + self.wide):
            for y in range(self.top_pos, self.top_pos + self.tall):
                pixels.append((x, y))
        return pixels


def solve_first(lines):
    claims = [Claim(line) for line in lines]
    ids_pixels = [(c.claim_id, c.pixels) for c in claims]
    pixels_claimed = defaultdict(lambda: [])
    for claim_id, pixels in ids_pixels:
        for pixel in pixels:
            pixels_claimed[pixel].append(claim_id)
    return len([claimers for claimers in pixels_claimed.values()
                if len(claimers) > 1])


def solve_second(lines):
    claims = [Claim(line) for line in lines]
    ids_pixels = [(c.claim_id, c.pixels) for c in claims]
    pixels_claimed = defaultdict(lambda: [])
    for claim_id, pixels in ids_pixels:
        for pixel in pixels:
            pixels_claimed[pixel].append(claim_id)
    all_claim_ids = set(claim.claim_id for claim in claims)
    conflicted = set()
    for pixel, claimers in pixels_claimed.items():
        if len(claimers) > 1:
            for claimer in claimers:
                conflicted.add(claimer)
    return all_claim_ids - conflicted


def main():
    with open('day03.txt', 'r') as infile:
        lines = infile.readlines()
    print(solve_first(lines))
    print(solve_second(lines))
