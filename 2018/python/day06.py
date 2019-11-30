class Point:

    def __init__(self, string, pid=None):
        self.pid = pid
        self.x, self.y = map(int, string.split(','))

    @staticmethod
    def from_coords(x, y):
        point = Point('0, 0')
        point.x = x
        point.y = y
        return point

    def distance(self, other):
        return abs((self.x - other.x) + (self.y - other.y))


class Grid:

    def __init__(self, points):
        self.origin = Point.from_coords(0, 0)
        self.points = points
        self.max_x = max(p.x for p in points) + 1
        self.max_y = max(p.y for p in points) + 1
        self.top_y = Point.from_coords(0, self.max_y)
        self.bot_x = Point.from_coords(self.max_x, 0)
        self.bot_y = Point.from_coords(self.max_x, self.max_y)

    def nearest(self, point):
        min_dist = self.max_x + self.max_y
        selected = None
        for p in self.points:
            curr_dist = point.distance(p)
            if curr_dist < min_dist and curr_dist > 0:
                min_dist = curr_dist
                selected = p
        return selected


def main():
    with open('day06.txt', 'r') as infile:
        lines = infile.readlines()
    print(solve_first(lines))


def solve_first(lines):
    points = [Point(line, pos) for pos, line in enumerate(lines)]
    grid = Grid(points)
    return grid
