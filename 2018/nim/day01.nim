import intsets, strutils
import itertools

var filename = "day01.txt"
# let contents = readFile(filename).splitLines.map(parseInt)
var contents = newSeq[int]()
for line in lines filename:
  contents.add(parseInt(line))

var sum = 0
for n in contents:
  sum += n
echo sum

var
  freq = 0
  seen = initIntSet()
for n in cycle contents:
  freq += n
  if freq in seen:
    echo freq
    break
  else:
    seen.incl(freq)
