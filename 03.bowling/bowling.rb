#!/usr/bin/env ruby

require 'debug'

# % ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5
# 139
# % ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X
# 164
# % ./bowling.rb 0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4
# 107
# % ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0
# 134
# % ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8
# 144
# % ./bowling.rb X,X,X,X,X,X,X,X,X,X,X,X
# 300
# % ./bowling.rb X,X,X,X,X,X,X,X,X,X,X,2
# 292
# % ./bowling.rb X,0,0,X,0,0,X,0,0,X,0,0,X,0,0
# 50

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0

frames.each_with_index do |frame, index|
  # 10フレーム以降は単純に加算する
  next point += frame.sum if index + 1 >= 10
  # スペアでもストライクでもない場合は単純に加算する
  next point += frame.sum if frame[0] != 10 && frame.sum != 10
  # スペアの場合は自フレームの得点と次フレームの1投目を加算する
  next point += frame.sum + frames[index + 1][0] if frame[0] != 10

  # ストライクの場合は次の2投分を加算する
  point +=
    # 次フレームがストライクの場合は、次フレーム+その次のフレームの1投分を加算する
    if frames[index + 1][0] == 10
      frame.sum + frames[index + 1].sum + frames[index + 2][0]
    else
      frame.sum + frames[index + 1].sum
    end
end
puts point
