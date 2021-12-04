class Board:
    def __init__(self, numbers):
        self.numbers = numbers
        self.markrows = [[False for _ in range(5)] for _ in range(5)]
        self.markcols = [[False for _ in range(5)] for _ in range(5)]

    def mark(self, number):
        for i in range(5):
            for j in range(5):
                if self.numbers[i][j] == number:
                    self.markrows[i][j] = True
                    self.markcols[j][i] = True

    def wins(self):
        return any(all(row) for row in self.markrows) or any(all(col) for col in self.markcols)

    def sum(self):
        total = 0
        for i in range(5):
            for j in range(5):
                if not self.markrows[i][j]:
                    total += self.numbers[i][j]
        return total

def parse(lines):
    numbers = [int(c) for c in lines[0].split(",")]
    boards = [e for e in split(lines[1:], "\n") if len(e) > 0]
    newboards = []
    for board in boards:
        newboard = []
        for line in board:
            newline = [int(c) for c in line.strip().split()]
            newboard.append(newline)
        newboards.append(newboard)
    return numbers, newboards


def split(sequence, sep):
    chunk = []
    for val in sequence:
        if val == sep:
            yield chunk
            chunk = []
        else:
            chunk.append(val)
    yield chunk

if __name__ == '__main__':
    with open("day04.txt", "r") as infile:
        lines = [line for line in infile]
    numbers, board_numbers = parse(lines)
    boards = [Board(bns) for bns in board_numbers]
    already_won = [False for _ in range(len(boards))]
    for number in numbers:
        for pos, board in enumerate(boards):
            board.mark(number)
            if board.wins() and not already_won[pos]:
                print(board.sum() * number)
                already_won[pos] = True
