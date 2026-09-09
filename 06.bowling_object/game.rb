# frozen_string_literal: true

require_relative './frame'
require_relative './shot'

class Game
  def initialize(score_string)
    remaining_marks = score_string.split(',')

    @frames = []
    10.times do |i|
      frame =
        if i < 9
          mark = remaining_marks.shift
          marks = Shot.new(mark).strike? ? [mark] : [mark, remaining_marks.shift]
          Frame.new(marks, index: i, frames: @frames)
        else
          Frame.new(remaining_marks, index: i, frames: @frames, last_frame: true)
        end
      @frames << frame
    end
  end

  def game_score
    @frames.sum(&:total_frame_score)
  end
end
