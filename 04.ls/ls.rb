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
  prepared_file_names = prepare_file_names_for_table(file_names)
  padding_size = prepared_file_names.map(&:length).max + PADDING_MARGIN
  row_size = (prepared_file_names.length / COLUMN_SIZE)
  table = prepared_file_names.each_slice(row_size).to_a.transpose
  table.each do |row_file_names|
    row_file_names.each do |file_name|
      print file_name.ljust(padding_size)
    end
    puts
  end
end

def prepare_file_names_for_table(file_names)
  lack_count = file_names.length % COLUMN_SIZE
  file_names.concat([''] * (COLUMN_SIZE - lack_count)) if lack_count.positive?
  file_names
end

def render_list(file_names)
  file_stats = file_names.map { |file_name| { name: file_name, stat: File.stat(file_name) } }
  rjust_options = build_rjust_options(file_stats)
  file_stats.each do |file_stat|
    puts build_file_stat_text(file_stat, rjust_options)
  end
  puts
end

def build_rjust_options(file_stats)
  {
    owner: max_owner_length(file_stats),
    group: max_group_length(file_stats) + 1,
    size: max_size_length(file_stats) + 1
  }
end

def max_owner_length(stats)
  stats.map { |stat| Etc.getpwuid(stat[:stat].uid).name.length }.max
end

def max_group_length(stats)
  stats.map { |stat| Etc.getgrgid(stat[:stat].gid).name.length }.max
end

def max_size_length(stats)
  stats.map { |stat| stat[:stat].size.to_s.length }.max
end

def build_file_stat_text(file_stat, rjust_options)
  name = file_stat[:name]
  stat = file_stat[:stat]
  [
    build_permission_text(stat),
    stat.nlink.to_s.rjust(2),
    build_file_info(stat, rjust_options),
    stat.mtime.strftime('%m %d %H:%M'),
    name
  ].join(' ')
end

def build_permission_text(stat)
  permission_text = stat.mode.to_s(8)[-3..].chars.map { |c| permission_char(c) }.join
  file_type_char(stat.ftype) + permission_text
end

def build_file_info(stat, rjust_options)
  [
    Etc.getpwuid(stat.uid).name.rjust(rjust_options[:owner]),
    Etc.getgrgid(stat.gid).name.rjust(rjust_options[:group]),
    stat.size.to_s.rjust(rjust_options[:size])
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
