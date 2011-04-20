require "test/unit"
require_relative "../lib/fraction"
include Simplex
F = Fraction
 
class TestFraction < Test::Unit::TestCase
  
  def setup
  end
  
  def teardown
  end
  
  def test_equality
    assert_equal(F.new(10,15),F.new(2,3))
    assert_equal(F.new(0,2),F.new(0,3))
    assert_not_equal(F.new(1,2),F.new(0,3))
    assert_not_equal(F.new(1,2), 0)
    assert_equal(F.new(9,9), 1)
  end
  
  def test_addition
    assert_equal(F.new(1,2)+F.new(1,2), 1)
    assert_equal(F.new(1,2)+F.new(1,3), F.new(5,6))
    assert_equal(F.new(1,2)+F.new(1,3), F.new(5,6))
  end
  
  def test_subtraction
    assert_equal(F.new(1,2)-F.new(1,2), 0)
    assert_equal(F.new(2,3)-1, F.new(-1,3))
    assert_equal(F.new(3,4)-F.new(1,2), F.new(2,8))
  end
  
  def test_multiplication
    assert_equal(F.new(-1,2)*F.new(-4,8), F.new(2,8))
    assert_equal(F.new(-1,2)*F.new(1,-2), F.new(2,8))
    assert_equal(F.new(-1,2)*F.new(2,7), F.new(-1,7))
  end
  
  def test_division
    assert_equal(F.new(-1,2)/F.new(1,-2), 1)
    assert_equal(F.new(-1,2)/F.new(1,-4), 2)
    assert_equal(F.new(-1,2)/F.new(2,7), F.new(-7,4))
  end
  
  def test_comparison
    assert(F.new(1,2) < 1.0 / 0)
    assert(F.new(1,2) < F.new(2,3))
    refute(F.new(2,4) > F.new(2,3))
    refute(F.new(2,4) == F.new(2,3))
    assert(F.new(2,4) <= F.new(4,8))
    assert(F.new(2,5) <= F.new(4,8))
    assert(F.new(2,5) < F.new(4,8))
    assert(F.new(2,5) == 0.4)
  end
  
end