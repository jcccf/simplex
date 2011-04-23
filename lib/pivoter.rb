require_relative 'fraction'
include Simplex

module Simplex
  class Pivoter
    def initialize
    end
    
    def print_matrix(a,d)
      a.each_with_index do |b,i|
        b.each do |c|
          print c
          print "\t"
        end
        print "| "
        print d[i]
        print "\n"
      end
      puts
    end

    def print_row(b,d)
      b.each do |c|
        print c
        print "\t"
      end
      print "| "
      print d
      print "\n"
      puts "---"
    end

    def pivot(a, ab, z, zb, add_constraint = false)
      rows = a.count-1
      cols = z.count-1
  
      # Convert to fractions
      z = z.map!{|x| Fraction.convert(x)}
      zb = Fraction.convert(zb)
      a = a.map!{|x| x.map{|y| Fraction.convert(y)}}
      ab = ab.map!{|x| Fraction.convert(x)}
      
      # Make last row suitable for dual simplex
      # TODO I wonder if this is truly correct
      if add_constraint
        new_row = a[-1].dup
        new_ab = ab[-1]
        a[-1].each_with_index do |nval,j|
          if nval != 0
            #puts "Looking for "+j.to_s
            # Find basic row corresponding to it
            a[0..-2].each_with_index do |row,i|
              if row[j] == 1
                row.each_with_index do |val,j2|
                  new_row[j2] -= val * nval
                end
                #puts "Index"+i.to_s
                new_ab -= ab[i] * nval
                #puts new_row.inspect
                #puts new_ab.inspect
                break
              end
            end
          end
        end
        a[-1] = new_row
        ab[-1] = new_ab
        puts "Converted last row into "
        print_row(a[-1],ab[-1])
      end

      # Convert to floats
      # z = z.map!{|x| x.to_f}
      # zb = zb.to_f
      # a = a.map!{|x| x.map{|y| y.to_f}}
      # ab = ab.map!{|x| x.to_f}

      # Find first negative c_j
      zj = -1
      (0..cols).each do |j|
        if z[j] < 0
          zj = j
          break
        end
      end
  
      # Do a normal simplex pivot
      if zj >= 0  
        # Find appropriate row to pivot on
        candidates = []
        (0..rows).each do |i|
          if ab[i] / a[i][zj] >= 0
            candidates << ab[i] / a[i][zj]
          else
            candidates << 1 / 0.0
          end
        end
        zi = candidates.index(candidates.min)
        type = "Simplex Pivot"
      # Attempt a dual simplex pivot
      else
        # Find the first negative b_i
        zi = -1
        (0..rows).each do |i|
          if ab[i] < 0
            zi = i
            break
          end
        end
    
        raise "Optimal" if zi < 0
    
        # Find appropriate column to pivot on
        candidates = []
        (0..cols).each do |j|
          if a[zi][j] < 0
            candidates << (z[j] / a[zi][j]).abs
          else
            candidates << 1 / 0.0
          end
        end
        zj = candidates.index(candidates.min)
        type = "Dual Simplex Pivot"
      end

      # Simplify that row
      divider = a[zi][zj]
      a[zi].map!{|x| x/divider}
      ab[zi] = ab[zi]/divider

      # Subtract from all other rows
      (0..rows).each do |i|
        if i != zi
          factor = a[i][zj]
          (0..cols).each do |j|
            a[i][j] -= factor * a[zi][j]
          end
          ab[i] -= factor * ab[zi]
        end
      end
      factor = z[zj]
      (0..cols).each do |j|
        z[j] -= factor * a[zi][j]
      end
      zb -= factor * ab[zi]

      puts "%s on row %d, column %d" % [type, zi+1, zj+1]
      print_row(z,zb)
      print_matrix(a,ab)
      [a, ab, z, zb]
    end

    def add_cutting_plane(a, ab, z, zb)
      rows = a.count-1
      cols = z.count-1
  
      # Convert to fractions
      z = z.map!{|x| Fraction.convert(x)}
      zb = Fraction.convert(zb)
      a = a.map!{|x| x.map{|y| Fraction.convert(y)}}
      ab = ab.map!{|x| Fraction.convert(x)}
  
      # # Convert to floats
      # z = z.map!{|x| x.to_f}
      # zb = zb.to_f
      # a = a.map!{|x| x.map{|y| y.to_f}}
      # ab = ab.map!{|x| x.to_f}
  
      # Find the first row with a fractional value
      ci = -1
      (0..rows).each do |i|
        if ab[i] - ab[i].floor > 0
          ci = i
          break
        end
      end
  
      raise "No cutting plane" if ci == -1
  
      puts "Cutting Plane generated from row %d" % ci
  
      # Generate the cutting plane row
      new_row = []
      (0..cols).each do |j|
        new_row << (a[ci][j].floor - a[ci][j])
      end
      new_row << 1.0
  
      a.map!{|x| x << 0.0 }
      a << new_row
      ab << (ab[ci].floor - ab[ci])
      z << 0.0
  
      print_row(z,zb)
      print_matrix(a,ab)
  
      [a, ab, z, zb]
    end

    # Generate solution to input which may or may not be integer-valued
    def optimize(a, ab, z, zb)
      begin
        a, ab, z, zb = pivot(a, ab, z, zb) while true
      rescue
        puts "Tableau is optimal!"
        puts
      end
      [a, ab, z, zb]
    end
    
    def optimize_add_constraint(a, ab, z, zb)
      begin
        a, ab, z, zb = pivot(a, ab, z, zb, true)
        a, ab, z, zb = pivot(a, ab, z, zb) while true
      rescue
        puts "Tableau is optimal!"
        puts
      end
      [a, ab, z, zb]
    end

    # Generate integer-valued solution to input
    def i_optimize(a, ab, z, zb)
      a, ab, z, zb = optimize(a, ab, z, zb)
      begin
        while true
          a, ab, z, zb = add_cutting_plane(a, ab, z, zb)
          a, ab, z, zb = optimize(a, ab, z, zb)
        end
      rescue
        puts "No more planes! Solution is integer!"
      end
    end
  end
end

# z = [0, 0, 1.25, 0.75, 0]
# zb = 41.25
# a = [[0, 1, 2.25, -0.25, 0], [1, 0, -1.25, 0.25, 0], [0, 0, -0.25, -0.75, 1]]
# ab = [2.25, 3.75, -0.25]

# z = [0, 0, 1, 0, 1, 0]
# zb = 41
# a = [[0, 1, 7.0/3, 0, -1.0/3, 0], [1, 0, -4.0/3, 0, 1.0/3, 0], [0, 0, 1.0/3, 1, -4.0/3, 0], [0, 0, -1.0/3, 0, -2.0/3, 1]]
# ab = [7.0/3, 11.0/3, 1.0/3, -1.0/3]

# z = [0, 0, 0.5, 0, 0, 1.5, 0]
# zb = 40.5
# a = [[0, 1, 2.5, 0, 0, -0.5, 0], [1, 0, -1.5, 0, 0, 0.5, 0], [0, 0, 1, 1, 0, -2, 0], [0, 0, 0.5, 0, 1.0, -1.5, 0], [0, 0, -0.5, 0, 0, -0.5, 1]]
# ab = [2.5, 3.5, 1, 0.5, -0.5]

#
# ---
#

# z = [0, 0, 0, 5.0/7, 3.0/7]
# zb = 30.0/7
# a = [[1, 0, 0, 1.0/7, 2.0/7],[0, 1, 0, -3.0/7, 22.0/7],[0, 0, 1, -2.0/7, 3.0/7]]
# ab = [13.0/7, 31.0/7, 9.0/7]

# z = [0, 0, 0, 5.0/7, 3.0/7, 0]
# zb = 30.0/7
# a = [[1, 0, 0, 1.0/7, 2.0/7, 0],[0, 1, 0, -3.0/7, 22.0/7, 0],[0, 0, 1, -2.0/7, 3.0/7, 0], [0, 0, 0, -1.0/7, -2.0/7, 1]]
# ab = [13.0/7, 31.0/7, 9.0/7, -6.0/7]

# a, ab, z, zb = pivot(a,ab,z,zb)
# a, ab, z, zb = pivot(a,ab,z,zb)
# pivot(a,ab,z,zb)

# z = [0, 1, 1.25, 0.75]
# zb = 41.25
# a = [[0,1,2.25,-0.25],[1,0,-1.25,0.25]]
# ab = [2.25, 3.75]
# add_cutting_plane(a,ab,z,zb)