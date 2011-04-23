require_relative '../lib/pivoter'
include Simplex

p = Pivoter.new

# Given the optimal tableau
# z + 3x3 + x5 + x6 = 14
#   x1 + 2x3 + x5 -x6 = 2
#   x2 - x3 - x5 + x6 = 2
#   - 3x3 + x4 - 2x5 + 3x6 = 1
# Add the new constraint x1 + x2 <= 3 
# or equivalently, x1 + x2 + x7 = 3
#
# The existing tableau must be optimal
# This new constraint must be in the last row

z = [0, 0, 3, 0, 1, 1, 0]
zb = 14
a = [[1, 0, 2, 0, 1, -2, 0], [0, 1, -1, 0, -1, 3, 0], [0, 0, -3, 1, -2, 3, 0], [1, 1, 0, 0, 0, 0, 1]]
ab = [2, 2, 1, 3]

a, ab, z, zb = p.optimize_add_constraint(a, ab, z, zb)