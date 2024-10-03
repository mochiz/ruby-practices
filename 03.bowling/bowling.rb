#!/usr/bin/env ruby

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
frames.each do |frame|
  point += if frame[0] == 10 # strike
             30
           elsif frame.sum == 10 # spare
             frame[0] + 10
           else
             frame.sum
           end
end
puts point
