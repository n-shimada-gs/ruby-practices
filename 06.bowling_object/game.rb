# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(score_string)
    marks = score_string.split(',')
    remaining = marks.dup

    frames_1to9 = []
    9.times do
      mark = remaining.shift
      frame_marks = mark == 'X' ? [mark] : [mark, remaining.shift]
      frames_1to9 << Frame.build(frame_marks)
    end

    frame10 = Frame.build(remaining, last_frame: true)

    @frames = frames_1to9 << frame10
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      frame.score + bonus(frame, index)
    end
  end

  private

  def bonus(frame, index)
    return 0 if index == 9
    return @frames[index + 1].first_point if frame.spare?
    return 0 unless frame.strike?

    if index == 8
      @frames[index + 1].bonus_points
    elsif @frames[index + 1].strike?
      @frames[index + 1].first_point + @frames[index + 2].first_point
    else
      @frames[index + 1].bonus_points
    end
  end
end
