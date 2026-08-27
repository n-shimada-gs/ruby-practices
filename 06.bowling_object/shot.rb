require_relative './frame'

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def point
    @mark == 'X' ? 10 : @mark.to_i
  end
end

shot = Shot.new('X')
shot.mark
shot.point
