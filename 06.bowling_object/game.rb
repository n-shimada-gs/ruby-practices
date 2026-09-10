# frozen_string_literal: true

require_relative './frame'
require_relative './shot'

class Game
  def initialize(score_string)
    remaining_marks = score_string.split(',')

    @frames = []
    10.times do |i|
      if i < 9
        shot = Shot.new(remaining_marks.shift)
        next_shot = shot.strike? ? [shot] : [shot, Shot.new(remaining_marks.shift)]
        @frames << Frame.new(next_shot, index: i, frames: @frames)
      else
        @frames << Frame.new(remaining_marks.map { |mark| Shot.new(mark) }, index: i, frames: @frames)
      end
    end
  end

  def game_score
    @frames.sum(&:total_frame_score)
  end
end
