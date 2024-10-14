#! /usr/bin/env ruby
# frozen_string_literal: true

COLUMN_SIZE = 3
PADDING_MARGIN = 1

items = Dir.children(__dir__)
items = items.sort.reject! { |item| item.start_with?('.') }

padding_size = items.map(&:length).max + PADDING_MARGIN

lack_count = items.length % COLUMN_SIZE
items.concat([''] * (COLUMN_SIZE - lack_count)) if lack_count.positive?

row_size = (items.length / COLUMN_SIZE)
matrix = items.each_slice(row_size).to_a.transpose
matrix.each do |row_items|
  row_items.each do |item|
    print item.ljust(padding_size)
  end
  puts
end
