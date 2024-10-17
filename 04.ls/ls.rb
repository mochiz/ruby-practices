#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_SIZE = 3
PADDING_MARGIN = 1

options = ARGV.getopts('a')

def get_sorted_file_names(options)
  file_names = Dir.entries(__dir__)
  if options['a']
    file_names.sort
  else
    file_names.sort.reject { |file_name| file_name.start_with?('.') }
  end
end

sorted_file_names = get_sorted_file_names(options)
padding_size = sorted_file_names.map(&:length).max + PADDING_MARGIN

lack_count = sorted_file_names.length % COLUMN_SIZE
sorted_file_names.concat([''] * (COLUMN_SIZE - lack_count)) if lack_count.positive?

row_size = (sorted_file_names.length / COLUMN_SIZE)
matrix = sorted_file_names.each_slice(row_size).to_a.transpose
matrix.each do |row_file_names|
  row_file_names.each do |file_name|
    print file_name.ljust(padding_size)
  end
  puts
end
