#!/usr/bin/env ruby

require 'date'
require 'optparse'

# デフォルト(引数を指定しない場合は、今月・今年のカレンダーが表示)
options = {
  m: Date.today.month,
  y: Date.today.year
}
# 引数設定
opt = OptionParser.new
opt.on('-y year', Integer) { |v| options[:y] = v }
opt.on('-m month', Integer) { |v| options[:m] = v }
opt.parse!(ARGV)

first_date = Date.new(options[:y], options[:m], 1)
last_date = Date.new(options[:y], options[:m], -1)

# ヘッダー
puts "#{options[:m]}月 #{options[:y]}".center(20)
puts "日 月 火 水 木 金 土"

# 1日までの空白
print "   " * first_date.wday

# 繰り返し日付表示
(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts "" if date.saturday?
end

# ターミナルのプロンプト巻き込み回避用
puts ""

