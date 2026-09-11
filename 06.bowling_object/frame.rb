# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(shots, index, frames)
    @shots = shots
    @index = index
    @frames = frames
  end

  def calc_score
    raw_score + calc_bonus
  end

  protected

  def raw_score
    @shots.sum(&:score)
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && raw_score == 10
  end

  def first_score
    @shots[0].score
  end

  def first_second_score
    @shots.first(2).sum(&:score)
  end

  private

  def calc_bonus
    return 0 if @index == 9

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
