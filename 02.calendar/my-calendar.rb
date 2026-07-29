#!/usr/bin/env ruby

require 'date'
require 'optparse'

# デフォルト(引数を指定しない場合は、今月・今年のカレンダーが表示)
options = {
    m:Date.today.month,
    y:Date.today.year
}
# 引数設定
opt = OptionParser.new
opt.on('-y year', Integer) {|v| options[:y] = v }
opt.on('-m month', Integer) {|v| options[:m] = v }
opt.parse!(ARGV)

today = Date.today
first_day = Date.new(options[:y], options[:m], 1)
first_wday = first_day.wday
last_day = Date.new(options[:y], options[:m], -1)

# ヘッダー
puts "     #{options[:m]}月 #{options[:y]}"
puts "日 月 火 水 木 金 土"

# 1日までの空白
print "   " * first_wday

# 繰り返し日付表示
(first_day..last_day).each do |date|
    print date.day.to_s.rjust(2) + " "

    if date.saturday?
        puts ""
    end
end

# ターミナルのプロンプト巻き込み回避用
puts ""