# frozen_string_literal: true
require 'set'
require_relative "ConvexHull/version"

module ConvexHull

  class Error < StandardError; end

  def self.jarvis(* points)
    n = points.length
  if n < 3
    return []
  end

  hull = []

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

  return hull
  end
end
