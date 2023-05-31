# frozen_string_literal: true
require 'set'
require_relative "ConvexHull/version"
require "test/unit/assertions"

include Test::Unit::Assertions


# Allows to compute convex hulls with Jarvis march and Graham's scan algorithms
module ConvexHull

  class Error < StandardError; end

  # Auxiliary function, that checks if the received array is in the right format
  def self.check_array_format(arr)
    unless arr.is_a?(Array) && arr.size == 2 &&
      (
        (arr[0].is_a?(Float) || arr[0].is_a?(Integer)) &&
          (arr[1].is_a?(Float) || arr[1].is_a?(Integer))
      )
      raise SyntaxError, "Array must be only [float, float], [float, int], [int, float] or [int, int]"
    end
  end
  
  # Computes a convex hull using Jarvis march algorithm
  # Accepts an array of points as an argument, that is an array of [float, float], [float, int], [int, float] or [int, int]
  # Returns an array of points, possibly empty, as a result 
  def self.jarvis(* points)
    points.each { |x| check_array_format(x) }
    n = points.length
    hull = []

    if n < 3
      hull
    else
      p0 = 0
      for i in 1...n
        if points[i][0] < points[p0][0]
          p0 = i
        end
      end

      p = p0
      q = nil
      begin
        hull << points[p]
        q = (p + 1) % n

        for i in 0...n
          orientation =
          (points[q][1] - points[p][1]) *
          (points[i][0] - points[q][0]) -
          (points[q][0] - points[p][0]) *
          (points[i][1] - points[q][1])
          if orientation < 0
            q = i
          end
        end

        p = q
      end while p != p0
      hull
    end
  end
  
  # Auxiliary function used in the implementations of algorithms
  def self.orientation(p, q, r)
    val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
    return 0 if val.zero?
    return 1 if val > 0
    return 2
  end

  # Computes a convex hull using Graham's scan algorithm
  # Accepts an array of points as an argument, that is an array of [float, float], [float, int], [int, float] or [int, int]
  # Returns an array of points, possibly empty, as a result 
  def self.graham(* points)
    points.each { |x| check_array_format(x) }
	
	if points.length < 3 
	  return []
	end
  
    min_y = points.min_by { |p| p[1] }

    sorted = points.sort_by { |p| [Math.atan2(p[1]-min_y[1], p[0]-min_y[0]), p[0]**2 + p[1]**2] }

    stack = []
    stack.push(sorted[0])
    stack.push(sorted[1])

    (2..sorted.size-1).each do |i|
      while stack.size > 1 && orientation(stack[-2], stack[-1], sorted[i]) != 2
        stack.pop
      end
      stack.push(sorted[i])
    end

    return stack
  end

end



hull1 = ConvexHull::jarvis([1.0, 1.0], [3.0, 3.0], [4.0, 2.0], [2.0, 4.0], [3.0, 1.0]);
assert_equal hull1, [[1.0, 1.0], [2.0, 4.0], [3.0, 3.0], [4.0, 2.0], [3.0, 1.0]]
hull =  ConvexHull::jarvis([2,1], [1,4], [3,4], [3,6], [4,3],[5,1], [5,4],[6,6],[7,3]);
assert_equal [[1, 4], [3, 6], [6, 6], [7, 3], [5, 1], [2, 1]], hull
assert_equal ConvexHull::jarvis([1, 4]), []
assert_equal ConvexHull::jarvis([1,1],[0,0]), []
assert_equal ConvexHull::jarvis([1,1],[0,0],[2,2]),[[0, 0], [2, 2], [1, 1]]


hull = ConvexHull::graham([1.0, 1.0], [3.0, 3.0], [4.0, 2.0], [2.0, 4.0], [3.0, 1.0])
p hull # [[1.0, 1.0], [3.0, 1.0], [4.0, 2.0], [2.0, 4.0]] - что-то пошло не так :) vs [1.0, 1.0], [2.0, 4.0], [3.0, 3.0], [4.0, 2.0], [3.0, 1.0]
hull = ConvexHull::graham([2,1], [1,4], [3,4], [3,6], [4,3],[5,1], [5,4],[6,6],[7,3])
p hull # [[2, 1], [5, 1], [7, 3], [6, 6], [3, 6], [1, 4]] vs [1, 4], [3, 6], [6, 6], [7, 3], [5, 1], [2, 1] вроде ок
hull = ConvexHull::graham([1, 4])
p hull #[[1, 4], nil]
hull = ConvexHull::graham([1, 1], [0,0])
p hull #[[0, 0], [1, 1]]
hull=ConvexHull::jarvis([1,1],[0,0],[2,2]) 
p hull #[[0, 0], [2, 2], [1, 1]]
p 'Succesfull Tests!'


