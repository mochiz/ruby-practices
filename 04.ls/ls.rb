#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_SIZE = 3
PADDING_MARGIN = 1

def main
  options = ARGV.getopts('ar')
  file_names = search_file_names(options)
  render_file_name_matrix(file_names)
end

def search_file_names(options = {})
  file_names = Dir.entries(__dir__).sort
  filtered_file_names = options['a'] ? file_names : file_names.reject { |file_name| file_name.start_with?('.') }
  options['r'] ? filtered_file_names.reverse : filtered_file_names
end

def render_file_name_matrix(file_names)
  prepared_file_names = prepare_file_names_for_matrix(file_names)
  padding_size = prepared_file_names.map(&:length).max + PADDING_MARGIN
  row_size = (prepared_file_names.length / COLUMN_SIZE)
  matrix = prepared_file_names.each_slice(row_size).to_a.transpose
  matrix.each do |row_file_names|
    row_file_names.each do |file_name|
      print file_name.ljust(padding_size)
    end
    puts
  end
end

def prepare_file_names_for_matrix(file_names)
  lack_count = file_names.length % COLUMN_SIZE
  file_names.concat([''] * (COLUMN_SIZE - lack_count)) if lack_count.positive?
  file_names
end

main
