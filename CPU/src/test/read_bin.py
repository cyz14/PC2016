
import sys

if len(sys.argv) < 2:
    print "Need bin file name" # len(sys.argv)


for _, argc in enumerate(sys.argv):
    pass # print argc

if sys.argv[1].endswith(".o"):
    file = open(sys.argv[1], "rb")
else:
    file = open("test.o", "rb")

line_num_in_hex = False
out_fmt_str = '%s%2d %2d %2d %2d'
if "-lx" in sys.argv:
    line_num_in_hex = True
    out_fmt_str = '%s%X %X %X %X'

data = file.read(-1)
insl = map(ord, data)
num = len(insl) / 2
for i in xrange(num):
    p0 = insl[i + i + 1]
    p1 = insl[i + i]
    line_num = ""
    if line_num_in_hex:
        line_num = "%04x: " % i
    print out_fmt_str % (line_num, p0 / 16, p0 % 16, p1 / 16, p1 % 16)
