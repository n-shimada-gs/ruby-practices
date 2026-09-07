# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(remaining_marks, last_frame: false)
    @last_frame = last_frame
    @shots =
      if last_frame
        remaining_marks.map { |mark| Shot.new(mark) }
      else
        first_shot = Shot.new(remaining_marks.shift)
        if first_shot.strike?
          [first_shot, Shot.new('0')]
        else
          [first_shot, Shot.new(remaining_marks.shift)]
        end
      end
  end

  def set_context(index, frames)
    @index = index
    @frames = frames
  end

  def score
    @shots.map(&:point).sum
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && score == 10
  end

  def first_point
    @shots[0].point
  end

  def bonus_points
    return score if @last_frame || !strike?
    return @shots.first(2).sum(&:point) if @index == 8

    10 + @frames[@index + 2].first_point
  end

  def total_points
    score + bonus
  end

  private

  def bonus
    return 0 if @last_frame
    return @frames[@index + 1].bonus_points if strike?
    return @frames[@index + 1].first_point if spare?

    0
  end
end
