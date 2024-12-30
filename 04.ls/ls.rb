#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_SIZE = 3
PADDING_MARGIN = 1
PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

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
  file_details = generate_file_details(file_names)
  width_options = generate_width_options(file_details)
  total_blocks = file_details.sum { |file_detail| file_detail[:stat].blocks }
  puts "total #{total_blocks}"
  file_details.each do |file_detail|
    puts generate_file_detail_text(file_detail, width_options)
  end
end

def generate_file_details(file_names)
  file_names.map do |file_name|
    file_stat = File.stat(file_name)
    {
      name: file_name,
      stat: file_stat,
      owner: Etc.getpwuid(file_stat.uid).name,
      group: Etc.getgrgid(file_stat.gid).name
    }
  end
end

def generate_width_options(file_details)
  {
    nlink: max_nlink_length(file_details) + PADDING_MARGIN,
    owner: max_owner_length(file_details) + PADDING_MARGIN,
    group: max_group_length(file_details),
    size: max_size_length(file_details) + PADDING_MARGIN
  }
end

def max_nlink_length(file_details)
  file_details.map { |file_detail| file_detail[:stat].nlink.to_s.length }.max
end

def max_owner_length(file_details)
  file_details.map { |file_detail| file_detail[:owner].length }.max
end

def max_group_length(file_details)
  file_details.map { |file_detail| file_detail[:group].length }.max
end

def max_size_length(file_details)
  file_details.map { |file_detail| file_detail[:stat].size.to_s.length }.max
end

def generate_file_detail_text(file_detail, width_options)
  permission = generate_permission(file_detail[:stat])
  nlink = generate_nlink_text(file_detail, width_options)
  owner = generate_owner_text(file_detail, width_options)
  group = generate_group_text(file_detail, width_options)
  size = generate_size_text(file_detail, width_options)
  mtime = generate_mtime_text(file_detail)
  file_name = file_detail[:name]
  [permission, nlink, owner, group, size, mtime, file_name].join(' ')
end

def generate_permission(file_stat)
  file_type = file_type_char(file_stat.ftype)
  permission = file_stat.mode.to_s(8)[-3..].chars.map { |c| PERMISSIONS[c] }.join
  "#{file_type}#{permission}"
end

def file_type_char(ftype)
  case ftype
  when 'file' then '-'
  when 'directory' then 'd'
  when 'link' then 'l'
  else ' '
  end
end

def generate_nlink_text(file_detail, width_options)
  file_detail[:stat].nlink.to_s.rjust(width_options[:nlink])
end

def generate_owner_text(file_detail, width_options)
  file_detail[:owner].ljust(width_options[:owner])
end

def generate_group_text(file_detail, width_options)
  file_detail[:group].ljust(width_options[:group])
end

def generate_size_text(file_detail, width_options)
  file_detail[:stat].size.to_s.rjust(width_options[:size])
end

def generate_mtime_text(file_detail)
  file_detail[:stat].mtime.strftime('%_m %_d %H:%M')
end

main
