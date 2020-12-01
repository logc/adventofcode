import sys

with open("day01.txt", "r") as infile:
    numbers = [int(line.strip()) for line in infile]

finished = False
for m in numbers:
    for n in numbers:
        if m + n == 2020:
            print(m * n)
            finished = True
    if finished:
        break

found = False
for m in numbers:
    for n in numbers:
        for i in numbers:
            if m + n + i == 2020:
                print(m * n * i)
                finished = True
        if found:
            break
    if found:
        break
