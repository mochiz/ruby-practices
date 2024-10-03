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
month = nil
year = nil
ARGV.each_with_index do |arg, index|
  if arg == '-m'
    month = ARGV[index + 1]
  elsif arg == '-y'
    year = ARGV[index + 1]
  end
end

puts "Month: #{month}"
puts "Year: #{year}"
