# frozen_string_literal: true

require_relative './frame'
require_relative './shot'

class Game
  def initialize(score_string)
    remaining_marks = score_string.split(',').map { |mark| Shot.new(mark) }

    @frames = []
    10.times do |i|
      if i < 9
        shot = remaining_marks.shift
        next_shots = shot.strike? ? [shot] : [shot, remaining_marks.shift]
        @frames << Frame.new(next_shots, i, @frames)
      else
        @frames << Frame.new(remaining_marks, i, @frames)
      end
    end
  end

  def calculate
    @frames.sum(&:calc_score)
  end
end
