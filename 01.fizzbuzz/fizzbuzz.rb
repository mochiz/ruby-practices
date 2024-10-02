# 1〜20まで数えて3の倍数の時はFizz、5の倍数の時はBuzz、3と5の倍数の時はFizzBuzzと表示する
20.times.each do |i|
  i+=1 
  if i % 3 == 0 && i % 5 == 0
    puts "FizzBuzz"
  elsif i % 3 == 0
    puts "Fizz"
  elsif i % 5 == 0
    puts "Buzz"
  else
    puts i
  end
end