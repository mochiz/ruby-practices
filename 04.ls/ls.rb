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
  file_stats = file_names.each_with_object({}) { |file_name, result| result[file_name] = File.stat(file_name) }
  width_options = generate_width_options(file_stats.values)
  total_blocks = file_stats.values.sum(&:blocks)
  puts "total #{total_blocks}"
  file_stats.each do |file_name, file_stat|
    puts generate_file_detail(file_name, file_stat, width_options)
  end
end

def generate_width_options(file_stats)
  {
    nlink_width: max_nlink_length(file_stats) + PADDING_MARGIN,
    owner_width: max_owner_length(file_stats) + PADDING_MARGIN,
    group_width: max_group_length(file_stats),
    size_width: max_size_length(file_stats) + PADDING_MARGIN
  }
end

def max_nlink_length(file_stats)
  file_stats.map { |file_stat| file_stat.nlink.to_s.length }.max
end

def max_owner_length(file_stats)
  file_stats.map { |file_stat| Etc.getpwuid(file_stat.uid).name.length }.max
end

def max_group_length(file_stats)
  file_stats.map { |file_stat| Etc.getgrgid(file_stat.gid).name.length }.max
end

def max_size_length(file_stats)
  file_stats.map { |file_stat| file_stat.size.to_s.length }.max
end

def generate_file_detail(file_name, file_stat, width_options)
  permission = generate_permission(file_stat)
  nlink = file_stat.nlink.to_s.rjust(width_options[:nlink_width])
  file_info = generate_file_info(file_stat, width_options)
  mtime = file_stat.mtime.strftime('%_m %_d %H:%M')
  "#{permission} #{nlink} #{file_info} #{mtime} #{file_name}"
end

def generate_permission(file_stat)
  file_type = file_type_char(file_stat.ftype)
  permission = file_stat.mode.to_s(8)[-3..].chars.map { |c| permission_char(c) }.join
  "#{file_type}#{permission}"
end

def generate_file_info(file_stat, width_options)
  owner = Etc.getpwuid(file_stat.uid).name.ljust(width_options[:owner_width])
  group = Etc.getgrgid(file_stat.gid).name.ljust(width_options[:group_width])
  size = file_stat.size.to_s.rjust(width_options[:size_width])
  "#{owner} #{group} #{size}"
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
  {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }[char]
end

main
