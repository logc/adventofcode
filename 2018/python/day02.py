from collections import defaultdict


def checksum(ids):
    doubles, triples = 0, 0
    for box_id in ids:
        doubles += count_doubles(box_id)
        triples += count_triples(box_id)
    return doubles * triples

def count_doubles(box_id):
    return count_reps(box_id, 2)

def count_triples(box_id):
    return count_reps(box_id, 3)

def count_reps(box_id, reps):
    counter = defaultdict(lambda: 0)
    for char in box_id:
        counter[char] += 1
    return 1 if any(v == reps for v in counter.values()) else 0

def are_correct_boxes(id_a, id_b):
    diffs = 0
    for pos in xrange(len(id_a)):
        diffs += 1 if id_a[pos] != id_b[pos] else 0
    return diffs == 1

def find_correct_boxes(box_ids):
    for box_id in box_ids:
        for other_box_id in box_ids:
            if are_correct_boxes(box_id, other_box_id):
                return box_id, other_box_id

def find_common_chars(id_a, id_b):
    common = ""
    for pos in xrange(len(id_a)):
        common += id_a[pos] if id_a[pos] == id_b[pos] else ""
    return common

if __name__ == '__main__':
    # print count_doubles("bababc"), count_triples("bababc")
    # print count_doubles("aabcdd"), count_triples("aabcdd")
    # print checksum(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])

    with open('day02.txt') as infile:
        puzzle_input = [line.strip() for line in infile]
    print checksum(puzzle_input)

    # print are_correct_boxes("abcde", "axcye")
    # print are_correct_boxes("fghij", "fguij")
    # example = ["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]
    # correct_id, other_id = find_correct_boxes(example)
    # print find_common_chars(correct_id, other_id)
    one_id, other_id = find_correct_boxes(puzzle_input)
    print find_common_chars(one_id, other_id)
