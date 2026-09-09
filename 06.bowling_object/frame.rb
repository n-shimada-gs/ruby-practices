# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(marks, index:, frames:, last_frame: false)
    @index = index
    @frames = frames
    @last_frame = last_frame
    @shots =
      if last_frame
        marks.map { |mark| Shot.new(mark) }
      else
        first_shot = Shot.new(marks[0])
        if first_shot.strike?
          [first_shot]
        else
          [first_shot, Shot.new(marks[1])]
        end
      end
  end

  def calc_frame
    @shots.sum(&:shot_score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && calc_frame == 10
  end

  def first_score
    @shots[0].shot_score
  end

  def first_second_score
    @shots.first(2).sum(&:shot_score)
  end

  def total_frame_score
    calc_frame + calc_bonus
  end

  private

  def calc_bonus
    return 0 if @last_frame

    if strike?
      next_frame = @frames[@index + 1]
      if @index == 8 || !next_frame.strike?
        next_frame.first_second_score
      else
        next_frame.first_score + @frames[@index + 2].first_score
      end
    elsif spare?
      @frames[@index + 1].first_score
    else
      0
    end
  end
end
