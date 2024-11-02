#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_SIZE = 3
PADDING_MARGIN = 1

def main
  options = ARGV.getopts('arl')
  file_names = search_file_names(options)
  options['l'] ? render_list(file_names) : render_table(file_names)
end

def search_file_names(options = {})
  file_names = Dir.entries(__dir__).sort
  filtered_file_names = options['a'] ? file_names : file_names.reject { |file_name| file_name.start_with?('.') }
  options['r'] ? filtered_file_names.reverse : filtered_file_names
end

def render_table(file_names)
  padding_size = file_names.map(&:length).max + PADDING_MARGIN
  file_name_table = generate_file_name_table(file_names)
  file_name_table.each do |row_file_names|
    row_file_names.each do |file_name|
      print file_name.ljust(padding_size)
    end
    puts
  end
end

def generate_file_name_table(file_names)
  lack_count = file_names.length % COLUMN_SIZE
  filled_file_names = lack_count.positive? ? file_names.concat([''] * (COLUMN_SIZE - lack_count)) : file_names
  row_size = (filled_file_names.length / COLUMN_SIZE)
  filled_file_names.each_slice(row_size).to_a.transpose
end

def render_list(file_names)
  file_stats = file_names.inject({}) { |hash, file_name| hash[file_name] = File.stat(file_name); hash }
  width_options = generate_width_options(file_stats.values)
  file_stats.each do |file_name, file_stat|
    puts generate_file_detail(file_name, file_stat, width_options)
  end
  puts
end

def generate_width_options(file_stats)
  {
    owner: max_owner_length(file_stats),
    group: max_group_length(file_stats) + PADDING_MARGIN,
    size: max_size_length(file_stats) + PADDING_MARGIN
  }
end

def max_owner_length(stats)
  stats.map { |stat| Etc.getpwuid(stat.uid).name.length }.max
end

def max_group_length(stats)
  stats.map { |stat| Etc.getgrgid(stat.gid).name.length }.max
end

def max_size_length(stats)
  stats.map { |stat| stat.size.to_s.length }.max
end

def generate_file_detail(file_name, file_stat, width_options)
  [
    generate_permission(file_stat),
    file_stat.nlink.to_s.rjust(2),
    generate_file_info(file_stat, width_options),
    file_stat.mtime.strftime('%m %d %H:%M'),
    file_name
  ].join(' ')
end

def generate_permission(stat)
  permission_text = stat.mode.to_s(8)[-3..].chars.map { |c| permission_char(c) }.join
  file_type_char(stat.ftype) + permission_text
end

def generate_file_info(stat, width_options)
  [
    Etc.getpwuid(stat.uid).name.rjust(width_options[:owner]),
    Etc.getgrgid(stat.gid).name.rjust(width_options[:group]),
    stat.size.to_s.rjust(width_options[:size])
  ].join(' ')
end

def file_type_char(ftype)
  case ftype
  when 'file' then '-'
  when 'directory' then 'd'
  when 'link' then 'l'
  else ''
  end
end

def permission_char(char)
  case char
  when '0' then '---'
  when '1' then '--x'
  when '2' then '-w-'
  when '3' then '-wx'
  when '4' then 'r--'
  when '5' then 'r-x'
  when '6' then 'rw-'
  when '7' then 'rwx'
  else ''
  end
end

main
