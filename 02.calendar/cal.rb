#! /usr/bin/env ruby

require 'date'

# $ ./cal.rb -m 11
#       11月 2019
# 日 月 火 水 木 金 土
#                 1  2
#  3  4  5  6  7  8  9
# 10 11 12 13 14 15 16
# 17 18 19 20 21 22 23
# 24 25 26 27 28 29 30

# -m  -y で月と年を指定してカレンダーを表示できるようにする
arg_month = nil
arg_year = nil
ARGV.each_with_index do |arg, index|
  if arg == '-m'
    arg_month = ARGV[index + 1]
  elsif arg == '-y'
    arg_year = ARGV[index + 1]
  end
end

year = arg_year&.to_i || Date.today.year
month = arg_month&.to_i || Date.today.month

start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)
dates = (start_date..end_date).to_a

puts "#{month}月 #{year}".center(21)
puts ' 日 月 火 水 木 金 土 '
print ' '.rjust(3) * start_date.wday # 月の初日の曜日まで空白で埋め
(start_date..end_date).each do |day|
  print day.day.to_s.rjust(3)
  print "\n" if day.saturday?
end
