# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',') # 投球毎に分割する

remaining = scores.dup
frames_1to9_raw = []
9.times do
  if remaining[0] == 'X' # ストライクの場合は1投分だけ取り出す
    frames_1to9_raw << remaining.shift
  else
    frames_1to9_raw << remaining.shift # ストライク以外の1投目
    frames_1to9_raw << remaining.shift # ストライク以外の2投目
  end
end
frame10_raw = remaining # 残りが10フレーム目の文字列データ

# 1-9フレーム分はダミー0付きで数値変換
frames_1to9_shots = []
frames_1to9_raw.each do |s|
  if s == 'X'
    frames_1to9_shots << 10
    frames_1to9_shots << 0
  else
    frames_1to9_shots << s.to_i
  end
end
frames = frames_1to9_shots.each_slice(2).to_a

# 10フレーム分はダミー0を入れずにそのまま数値変換
frame10_shots = frame10_raw.map do |s|
  s == 'X' ? 10 : s.to_i
end

# 1-9フレームの得点計算
point_1to9 = frames.each_with_index.sum do |frame, i|
  if frame[0] == 10 # strike
    if i == 8 # 9フレーム目のストライクはframe10_shotsの2投分を見る
      10 + frame10_shots[0] + frame10_shots[1]
    elsif frames[i + 1][0] == 10 # ダブルストライク用
      10 + 10 + (i + 2 < frames.length ? frames[i + 2][0] : frame10_shots[0])
    else
      10 + frames[i + 1].sum # 通常のストライクの計算
    end
  elsif frame.sum == 10 # spare
    if i == 8 # 9フレーム目のスペアはframe10_shotsの1投分を見る
      frame.sum + frame10_shots[0]
    else
      frame.sum + frames[i + 1][0]
    end
  else
    frame.sum
  end
end

# 10フレームの得点計算
point10 = frame10_shots.sum

point = point_1to9 + point10
puts point
