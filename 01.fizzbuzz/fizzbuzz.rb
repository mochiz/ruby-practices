#! /usr/bin/env ruby

# 1〜20まで数えて3の倍数の時はFizz、5の倍数の時はBuzz、3と5の倍数の時はFizzBuzzと表示する
(1..20).each do |i|
  if (i % 3).zero? && (i % 5).zero?
    puts 'FizzBuzz'
  elsif (i % 3).zero?
    puts 'Fizz'
  elsif (i % 5).zero?
    puts 'Buzz'
  else
    puts i
  end
end
