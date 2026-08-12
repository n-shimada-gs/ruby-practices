# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.map { |s| s == 'X' ? 10 : s.to_i }
remaining = shots.dup

frames_1to9_shots = []
9.times do
  shot = remaining.shift
  frames_1to9_shots << shot
  frames_1to9_shots << if shot == 10
                         0
                       else
                         remaining.shift # ストライク以外の2投目
                       end
end

frame10_shots = remaining

frames = frames_1to9_shots.each_slice(2).to_a << frame10_shots

point = frames.each_with_index.sum do |frame, i|
  bonus =
    if i == 9
      0
    elsif frame[0] == 10 # strike
      if i == 8
        frames[i + 1][0, 2].sum
      elsif frames[i + 1][0] == 10
        10 + frames[i + 2][0]
      else
        frames[i + 1].sum
      end
    elsif frame.sum == 10 # spare
      frames[i + 1][0]
    else
      0
    end
  frame.sum + bonus
end
puts point
