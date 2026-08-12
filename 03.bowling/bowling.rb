# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',') # 投球毎に分割する
shots = scores.map { |s| s == 'X' ? 10 : s.to_i }
remaining = shots.dup

frames_1to9_shots = []
9.times do
  shot = remaining.shift
  frames_1to9_shots << shot
  if shot == 10
    frames_1to9_shots << 0
  else
    frames_1to9_shots << remaining.shift # ストライク以外の2投目
  end
end

frame10_shots = remaining # 残りが10フレーム目の文字列データ

frames = (frames_1to9_shots.each_slice(2).to_a) << frame10_shots

point = frames.each_with_index.sum do |frame, i|
  if i == 9
    frame.sum
  elsif frame[0] == 10 # strike
    if i == 8
      10 + frames[i + 1][0] + frames[i + 1][1]
    elsif frames[i + 1][0] == 10 # ダブルストライク
      10 + 10 + frames[i + 2][0]
    else
      10 + frames[i + 1].sum # 通常のストライクの計算
    end
  elsif frame.sum == 10 # spare
      frame.sum + frames[i + 1][0]
  else
    frame.sum
  end
end
puts point
