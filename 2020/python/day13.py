from math import pow


def parse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    earliest, bus_ids = lines[0], lines[1]
    earliest = int(earliest)
    bus_ids = [int(bus_id) for bus_id in bus_ids.split(",") if bus_id != "x"]
    return earliest, bus_ids


def earliest_can_take(earliest, bus_ids):
    near_earliest = []
    for bus_id in bus_ids:
        prevt = earliest // bus_id
        nextt = (prevt + 1) * bus_id
        near_earliest.append(nextt)
    mint = min(near_earliest)
    min_bus_id = bus_ids[near_earliest.index(mint)]
    return min_bus_id, mint


def solve_one(earliest, bus_ids):
    min_bus_id, min_ts = earliest_can_take(earliest, bus_ids)
    wait_time = min_ts - earliest
    return min_bus_id * wait_time


def reparse(text):
    lines = [line for line in text.split("\n") if len(line) > 0]
    earliest, bus_ids = lines[0], lines[1]
    earliest = int(earliest)
    indexed_bus_ids = []
    for idx, bus_id in enumerate(bus_ids.split(",")):
        if bus_id == "x":
            continue
        indexed_bus_ids.append((idx, int(bus_id)))
    return indexed_bus_ids


def earliest_matching_index(offset_freqs):
    ts = 0
    max_offset_freq = max(offset_freqs, key=lambda x: x[1])
    index_max = offset_freqs.index(max_offset_freq)
    offset_max = offset_freqs[index_max][0]
    corr_offset_freqs = [(offset - offset_max, freq)
                         for offset, freq in offset_freqs]
    period = max_offset_freq[1]
    found = False
    n = 0
    while not found:
        ts += period
        if ts > pow(10, n):
            n += 1
            print(f"Trying {ts}")
        found = all((ts + idx) % bid == 0 for idx, bid in corr_offset_freqs)
    return ts - offset_max


def solve_two(indexed_bus_ids):
    return earliest_matching_index(indexed_bus_ids)


if __name__ == '__main__':
    with open("day13.txt", "r") as infile:
        puzzle_input = infile.read()
    earliest, bus_ids = parse(puzzle_input)
    indexed_bus_ids = reparse(puzzle_input)
    one = solve_one(earliest, bus_ids)
    two = solve_two(indexed_bus_ids)
    print(f"Puzzle #1: {one}")
    print(f"Puzzle #2: {two}")
