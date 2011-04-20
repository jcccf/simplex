require_relative '../lib/pivoter'
include Simplex

p = Pivoter.new

# The following solves
# max   z
# s.t.  z - 8x -5y = 0
#       x + y + s1 = 6
#       9x + 5y + s2 = 45
#       x, y, s1, s2 >= 0
# Requires that you have added the slack variables

z = [-8, -5, 0, 0]
zb = 0
a = [[1, 1, 1, 0], [9, 5, 0, 1]]
ab = [6, 45]

p.optimize(a, ab, z, zb)
p.i_optimize(a, ab, z, zb)
