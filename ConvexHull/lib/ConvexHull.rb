# frozen_string_literal: true
require 'set'
require_relative "ConvexHull/version"

module ConvexHull

  class Error < StandardError; end

  def self.check_array_format(arr)
    unless arr.is_a?(Array) && arr.size == 2 &&
      (
        (arr[0].is_a?(Float) || arr[0].is_a?(Integer)) &&
          (arr[1].is_a?(Float) || arr[1].is_a?(Integer))
      )
      raise SyntaxError, "Array must be only [float, float], [float, int], [int, float] or [int, int]"
    end
  end
  
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
  
  
  def self.orientation(p, q, r)
    val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
    return 0 if val.zero?
    return 1 if val > 0
    return 2
  end


  def self.graham(* points)
    points.each { |x| check_array_format(x) }
  
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