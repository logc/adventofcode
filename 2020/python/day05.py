def parse(line):
    row_spec, seat_spec = line[:7], line[7:]
    return row_spec, seat_spec


def halve(alist):
    middle = len(alist) // 2
    lower, upper = alist[:middle], alist[middle:]
    return lower, upper


def select_half(spec, arange):
    lower, upper = halve(arange)
    return lower if spec in ["F", "L"] else upper


def find_row(row_spec):
    rows = list(range(128))
    for row in row_spec:
        rows = select_half(row, rows)
    assert len(rows) == 1
    return rows[0]


def find_seat(seat_spec):
    seats = list(range(8))
    for seat in seat_spec:
        seats = select_half(seat, seats)
    assert len(seats) == 1
    return seats[0]


def find_full_seat(row_spec, seat_spec):
    row = find_row(row_spec)
    seat = find_seat(seat_spec)
    seat_id = row * 8 + seat
    return row, seat, seat_id


def solve_one(seats):
    max_by_id = max(seats, key=lambda seat: seat[2])
    return max_by_id[2]


def find_missing_seats(seats):
    seen = set()
    for seat in seats:
        seen.add(seat)
    missing = []
    for row in range(128):
        for seat in range(8):
            seat_id = row * 8 + seat
            full_seat = (row, seat, seat_id)
            if not (full_seat in seen):
                missing.append(full_seat)
    return missing


def parse_input(filename):
    with open(filename, "r") as infile:
        lines = [parse(line.strip()) for line in infile]
    return lines


def solve_two(seats):
    missing = find_missing_seats(seats)
    previous = 0
    for seat in missing:
        row, _, seat_id = seat
        if row > previous + 1:
            return seat_id
        else:
            previous = row


if __name__ == '__main__':
    lines = parse_input("day05.txt")
    seats = [find_full_seat(r, s) for r, s in lines]
    print("Puzzle #1: {}".format(solve_one(seats)))
    print("Puzzle #2: {}".format(solve_two(seats)))
