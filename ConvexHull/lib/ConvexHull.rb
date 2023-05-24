# frozen_string_literal: true
require 'set'
require_relative "ConvexHull/version"

module ConvexHull

  class Error < StandardError; end
  
  def self.jarvis(* points)
    p0 = points[0]
    points.each { |p|
      if p[:x] < p0[:x] || (p[:x] == p0[:x] && p[:y] < p0[:y])
        p0 = p
      end
    }
    hull = [p0].to_set
    while true
      t = p0
      points.each do |p|
        if()
      end
    end
  end
end
