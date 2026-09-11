# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def strike?
    @mark == 'X'
  end

  def score
    strike? ? 10 : @mark.to_i
  end
end
