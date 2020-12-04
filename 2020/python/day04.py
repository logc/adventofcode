import string
from itertools import groupby


VALID_FIELDS = [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
    "cid"
]


def parse(line):
    tokens = line.split(" ")
    field_values = [token.split(":", 1) for token in tokens]
    return {k: v for k, v in field_values}


def valid(passport, fields):
    required_fields = [field for field in fields if field != "cid"]
    return all(field in passport for field in required_fields)


def solve_one(passports):
    return sum(valid(passport, VALID_FIELDS) for passport in passports)


def read_file(contents):
    lines = contents.split("\n")
    lines = [line.strip() for line in lines]
    passport_groups = []
    current_passport = []
    for line in lines:
        line = line.strip()
        if line == "":
            passport_groups.append(current_passport)
            current_passport = []
        else:
            current_passport.append(line)
    # passport_groups = [list(g) for k, g in groupby(
    #     lines, lambda line: len(line) == 0) if not k]
    passport_lines = [" ".join(s for s in group)
                      for group in passport_groups]
    return passport_lines


def valid_number(value, min_val, max_val):
    try:
        number = int(value)
        return min_val <= number <= max_val
    except ValueError:
        return False


def valid_birthyear(value):
    return valid_number(value, 1920, 2002)


def valid_issueyear(value):
    return valid_number(value, 2010, 2020)


def valid_expirationyear(value):
    return valid_number(value, 2020, 2030)


def valid_height(value):
    height, units = value[:-2], value[-2:]
    if units == "cm":
        return valid_number(height, 150, 193)
    elif units == "in":
        return valid_number(height, 59, 76)
    else:  # e.g. no units
        return False


def valid_haircolor(value):
    hash_char, rest = value[0], value[1:]
    if hash_char != "#":
        return False
    if len(rest) != 6:
        return False
    a_f = string.ascii_lowercase[:6]
    valid_chars = a_f + string.digits
    if any(char not in valid_chars for char in rest):
        return False
    else:
        return True


def valid_eyecolor(value):
    return value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]


def valid_pid(value):
    return len(value) == 9 and all(char in string.digits for char in value)


def validate(passport):
    return (valid(passport, VALID_FIELDS) and
            valid_birthyear(passport["byr"]) and
            valid_issueyear(passport["iyr"]) and
            valid_expirationyear(passport["eyr"]) and
            valid_height(passport["hgt"]) and
            valid_haircolor(passport["hcl"]) and
            valid_eyecolor(passport["ecl"]) and
            valid_pid(passport["pid"])
            )


def solve_two(passports):
    return sum(validate(passport) for passport in passports)


if __name__ == '__main__':
    with open("day04.txt", "r") as infile:
        contents = infile.read()
    passport_lines = read_file(contents)
    passports = [parse(line) for line in passport_lines]
    print("Puzzle #1: {}".format(solve_one(passports)))
    print("Puzzle #2: {}".format(solve_two(passports)))
