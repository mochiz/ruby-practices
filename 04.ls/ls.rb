#! /usr/bin/env ruby
# frozen_string_literal: true

# 列数を指定する
COLUMN_SIZE = 3
# 文字幅調整用のマージン
PADDING_MARGIN = 1

children = Dir.children(__dir__)
children.sort!.reject! { |child| child.start_with?('.') }

# 文字幅調整用に最大文字数を取得する
padding_size = children.map(&:length).max + PADDING_MARGIN

# 配列がCOMUNS_SIZEの倍数になるように空文字で埋める
lack_count = children.length % COLUMN_SIZE
children.concat([''] * (COLUMN_SIZE - lack_count)) if lack_count.positive?

# 行列を入れ替えた二次元配列を作成する
divider = (children.length / COLUMN_SIZE)
matrix = children.each_slice(divider).to_a.transpose
matrix.each do |row|
  row.each do |item|
    print item.ljust(padding_size)
  end
  puts
end
