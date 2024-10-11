#! /usr/bin/env ruby
# frozen_string_literal: true

# 列数を指定する
COLUMN_SIZE = 3
# 文字幅調整用のマージン
PADDING_MARGIN = 1

items = Dir.children(__dir__)
items = items.sort.reject! { |item| item.start_with?('.') }

# 文字幅調整用に最大文字数を取得する
padding_size = items.map(&:length).max + PADDING_MARGIN

# 配列がCOMUNS_SIZEの倍数になるように空文字で埋める
lack_count = items.length % COLUMN_SIZE
items.concat([''] * (COLUMN_SIZE - lack_count)) if lack_count.positive?

# 行列を入れ替えた二次元配列を作成する
row_size = (items.length / COLUMN_SIZE)
matrix = items.each_slice(row_size).to_a.transpose
matrix.each do |row|
  row.each do |item|
    print item.ljust(padding_size)
  end
  puts
end
