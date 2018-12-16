from itertools import cycle

def solve_first():
    with open('day01.txt', 'r') as infile:
        lines = infile.readlines()
        numbers = [int(line.strip()) for line in lines]
        print sum(numbers)

def find_first_repeated(freqs):
    seen = set()
    current = 0
    seen.add(current)
    for change in cycle(freqs):
        current += change
        if current in seen:
            print current
            break
        else:
            seen.add(current)

def solve_second():
    with open('day01.txt', 'r') as infile:
        freqs = [int(line.strip()) for line in infile]
        find_first_repeated(freqs)

if __name__ == "__main__":
    #find_first_repeated([1, -1])
    #find_first_repeated([3, 3, 4, -2, -4])
    solve_first()
    solve_second()
