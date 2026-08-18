# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

remaining = scores.dup
frames_1to9_shots = []
9.times do
  shot = remaining.shift
  if shot == 'X'
    frames_1to9_shots << 10
    frames_1to9_shots << 0
  else
    frames_1to9_shots << shot.to_i
    frames_1to9_shots << remaining.shift.to_i
  end
end

frame10_shots = remaining.map { |s| s == 'X' ? 10 : s.to_i }

frames = frames_1to9_shots.each_slice(2).to_a << frame10_shots

point = frames.each_with_index.sum do |frame, i|
  bonus =
    if i == 9
      0
    elsif frame[0] == 10 # strike
      if i == 8
        frames[i + 1][0, 2].sum
      elsif frames[i + 1][0] == 10
        frames[i + 1, 2].map(&:first).sum
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
