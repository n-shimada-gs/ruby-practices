require_relative './shot'

class Frame
  def initialize(first_shot, second_shot, third_shot = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark) if third_shot
  end

  def score
    total_score = @first_shot.score + @second_shot.score
    total_score += @third_shot.score if @third_shot
    total_score
  end

  def strike?
    @first_shot.mark == 'X'
  end

  def spare?

  end

frame = Frame.new('7', '2')
frame.score
