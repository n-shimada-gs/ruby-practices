# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(score_string)
    remaining_marks = score_string.split(',')

    @frames = 10.times.map do |i|
      if i < 9
        Frame.new(remaining_marks)
      else
        Frame.new(remaining_marks, last_frame: true)
      end
    end

    @frames.each_with_index do |frame, i|
      frame.set_context(i, @frames)
    end
  end

  def final_score
    @frames.sum(&:total_points)
  end
end
