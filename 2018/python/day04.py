import re
from datetime import datetime
from collections import defaultdict
from itertools import tee

PATTERN = re.compile(r"\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2})\]")
DATE_FMT = "%Y-%m-%d %H:%M"


class Record:

    def __init__(self, string):
        matches = re.match(PATTERN, string)
        self.timestamp = datetime.strptime(matches.group(1), DATE_FMT)
        if 'Guard' in string:
            self.guard_id = int(re.search(r"Guard #(\d*)", string).group(1))
            self.awake = True
        else:
            self.guard_id = None
            self.awake = 'wakes up' in string


def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)


def main():
    with open('day04.txt', 'r') as infile:
        lines = infile.readlines()
    print(solve_first(lines))
    print(solve_second(lines))


def parse_timelines(lines):
    records = [Record(line) for line in lines]
    records = sorted(records, key=lambda x: x.timestamp)
    current_guard_id = records[0].guard_id
    for record in records:
        if record.guard_id:
            current_guard_id = record.guard_id
        else:
            record.guard_id = current_guard_id
    guard_timelines = defaultdict(list)
    for record in records:
        guard_timelines[record.guard_id].append(record)
    return guard_timelines


def solve_first(lines):
    guard_timelines = parse_timelines(lines)
    results = []
    for guard_id in guard_timelines:
        total = 0
        freqs = dict((m, 0) for m in range(0, 60))
        for start, end in pairwise(guard_timelines[guard_id]):
            if end.awake and not start.awake:
                mins = (end.timestamp - start.timestamp).total_seconds() / 60
                minutes = list(range(start.timestamp.minute, end.timestamp.minute))
                total += mins
                for m in minutes:
                    freqs[m] += 1
        most_frequent = max(freqs, key=(lambda k: freqs[k]))
        results.append((guard_id, total, most_frequent))
    max_by_total = max(results, key=lambda r: r[1])
    guard_id, total, minute = max_by_total
    return guard_id * minute


def solve_second(lines):
    guard_timelines = parse_timelines(lines)
    results = []
    for guard_id in guard_timelines:
        freqs = dict((m, 0) for m in range(0, 60))
        for start, end in pairwise(guard_timelines[guard_id]):
            if end.awake and not start.awake:
                minutes = list(range(start.timestamp.minute, end.timestamp.minute))
                for m in minutes:
                    freqs[m] += 1
        most_frequent = max(freqs, key=(lambda k: freqs[k]))
        results.append((guard_id, freqs[most_frequent], most_frequent))
    max_by_partial = max(results, key=lambda r: r[1])
    guard_id, total, minute = max_by_partial
    return guard_id * minute

if __name__ == "__main__":
    main()
