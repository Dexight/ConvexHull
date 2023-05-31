# frozen_string_literal: true

#require "test_helper"

require '../lib/ConvexHull'
require 'test/unit'
class TestConvexHull < Test::Unit::TestCase
  #def test_that_it_has_a_version_number
   # refute_nil ::ConvexHull::VERSION
  #end

  #def test_it_does_something_useful
   # assert false
  #end
  
  def test_jarvis_1
	hull1 = ConvexHull::jarvis([1.0, 1.0], [3.0, 3.0], [4.0, 2.0], [2.0, 4.0], [3.0, 1.0]);
	assert_equal hull1, [[1.0, 1.0], [2.0, 4.0], [3.0, 3.0], [4.0, 2.0], [3.0, 1.0]]
  end
  
  def test_jarvis_2
	hull =  ConvexHull::jarvis([2,1], [1,4], [3,4], [3,6], [4,3],[5,1], [5,4],[6,6],[7,3]);
    assert_equal [[1, 4], [3, 6], [6, 6], [7, 3], [5, 1], [2, 1]], hull
  end
  
  def test_not_convex
    assert_equal ConvexHull::jarvis([1, 4]), []
    assert_equal ConvexHull::jarvis([1,1],[0,0]), []
  end
  
  def test_triangle
	assert_equal ConvexHull::jarvis([1,1],[0,0],[2,2]),[[0, 0], [2, 2], [1, 1]]
  end
    
  def test_graham_2
	hull = ConvexHull::graham([2,1], [1,4], [3,4], [3,6], [4,3],[5,1], [5,4],[6,6],[7,3])
	assert_equal hull, [[2, 1], [5, 1], [7, 3], [6, 6], [3, 6], [1, 4]]
  end
  
  def test_graham_nil
	hull = ConvexHull::graham([1, 4])
	assert_equal hull, []
  end
  
  def test_graham_nil_2
    hull = ConvexHull::graham([1, 1], [0,0])
	assert_equal hull, []
  end
  
end
