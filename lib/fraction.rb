module Simplex
  class Fraction
    attr_accessor :n, :d
  
    def initialize(num,dem)
      raise "Fraction cannot have zero denominator" if dem == 0
      warn "Numerator wasn't an integer, converting" if num.to_i != num
      warn "Denominator wasn't an integer, converting" if num.to_i != num
      a, b = simplify(num.to_i, dem.to_i)
      @n = a
      @d = b
    end
  
    def self.convert(unknown)
      if unknown.respond_to?(:is_fraction?)
        unknown
      else
        Fraction.new(unknown,1)
      end
    end
  
    def +(frac)
      if frac.respond_to?(:is_fraction?)
        l = lcm(frac.d, @d)
        m2 = l/frac.d
        m1 = l/@d
        sum_num = m1 * @n + m2 * frac.n
        a, b = simplify(sum_num,l)
        Fraction.new(a, b)
      else
        self+(Fraction.new(frac,1))
      end
    end
  
    def -(frac)
      if frac.respond_to?(:is_fraction?)
        self+(Fraction.new(-frac.n,frac.d))
      else
        self+(Fraction.new(-frac,1))
      end
    end
  
    def *(frac)
      if frac.respond_to?(:is_fraction?)
        top = @n * frac.n
        bottom = @d * frac.d
        gcd = greatest_common_divisor(top, bottom)
        Fraction.new(top/gcd, bottom/gcd)
      else
        self*(Fraction.new(frac,1))
      end
    end
  
    def /(frac)
      if frac.respond_to?(:is_fraction?)
        self*(Fraction.new(frac.d,frac.n))
      else
        self*(Fraction.new(1,frac))
      end
    end
  
    def <=>(frac)
      if frac.respond_to?(:is_fraction?)
        return 1 if (self-frac).n > 0
        return -1 if (self-frac).n < 0
        return 0 if (self-frac).n == 0
      else
        self.to_f <=> frac
      end
    end
  
    def <(frac)
      (self <=> frac) == -1
    end
  
    def <=(frac)
      (self <=> frac) == -1 || (self <=> frac) == 0
    end
  
    def >(frac)
      (self <=> frac) == 1
    end
  
    def >=(frac)
      (self <=> frac) == 1 || (self <=> frac) == 0
    end
    
    def ==(frac)
      (self <=> frac) == 0
    end
  
    def abs
      Fraction.new(@n.abs,@d.abs)
    end
  
    def floor
      Fraction.new((@n.to_f/@d.to_f).floor,1)
    end
    
    def to_f
      @n.to_f / @d.to_f
    end
  
    def to_s
      if @d == 1
        "%d" % @n
      else
        "%d/%d" % [@n,@d]
      end
    end
  
    def is_fraction?
      true
    end
  
    private
    
    def simplify(a, b)
      gcd = greatest_common_divisor(a,b)
      [a/gcd, b/gcd]
    end
    
    def lcm(a, b)
      a * b / greatest_common_divisor(a,b)
    end

    def greatest_common_divisor(a, b)
       while a%b != 0
         a,b = b.round,(a%b).round
       end 
       return b
    end
  end
end