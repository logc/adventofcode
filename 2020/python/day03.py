def parse(line):
    grid_line = []
    for char in line:
        if char == ".":
            grid_line.append(0)
        elif char == "#":
            grid_line.append(1)
    return grid_line


def traverse(grid, slope):
    slope_x, slope_y = slope
    x, y = 0, 0
    trees = 0
    width = len(grid[0])
    while x < len(grid) - 1:
        x += slope_x
        y += slope_y
        y = y % width
        trees += grid[x][y]
    return trees


def solve_one(grid):
    slope = (1, 3)
    return traverse(grid, slope)


def solve_two(grid):
    slope1 = (1, 1)
    slope2 = (1, 3)
    slope3 = (1, 5)
    slope4 = (1, 7)
    slope5 = (2, 1)
    trees1 = traverse(grid, slope1)
    trees2 = traverse(grid, slope2)
    trees3 = traverse(grid, slope3)
    trees4 = traverse(grid, slope4)
    trees5 = traverse(grid, slope5)
    return trees1 * trees2 * trees3 * trees4 * trees5


if __name__ == '__main__':
    with open("day03.txt", "r") as infile:
        grid = [parse(line) for line in infile]
    print("Puzzle #1: {}".format(solve_one(grid)))
    print("Puzzle #2: {}".format(solve_two(grid)))
