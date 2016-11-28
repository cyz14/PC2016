
import sys

if len(sys.argv) > 0:
    print len(sys.argv)

for _, argc in enumerate(sys.argv):
    print argc
    
print
    
file = open("fibonacci.o", "rb")

data = file.read(-1)
insl = map(ord, data)
num = len(insl) / 2
for i in xrange(num):
    p0 = insl[i + i + 1]
    p1 = insl[i + i]
    print '%d %d %d %d' % (p0 / 16, p0 % 16, p1 / 16, p1 % 16)
