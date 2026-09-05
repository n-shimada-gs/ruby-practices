# frozen_string_literal: true

require_relative './shot'

class Frame
  def self.build(marks, last_frame: false)
    shots =
      if last_frame
        marks.map { |mark| Shot.new(mark) }
      elsif marks[0] == 'X'
        [Shot.new('X'), Shot.new('0')]
      else
        [Shot.new(marks[0]), Shot.new(marks[1])]
      end
    new(shots)
  end

  def initialize(shots)
    @shots = shots
  end

  def score
    @shots.map(&:point).sum
  end

  def strike?
    @shots[0].mark == 'X'
  end

  def spare?
    !strike? && score == 10
  end

  def first_point
    @shots[0].point
  end

  def bonus_points
    @shots.first(2).sum(&:point)
  end
end
