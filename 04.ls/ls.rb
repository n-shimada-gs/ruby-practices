#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
COLS = 3

def fetch_files(opt, target_dir = '.')
  flags = opt['a'] ? File::FNM_DOTMATCH : 0
  files_list = Dir.glob('*', base: target_dir, flags: flags)
  opt['r'] ? files_list.reverse : files_list
end

def file_type(stat)
  case stat.ftype
  when 'file' then '-'
  when 'directory' then 'd'
  when 'link' then 'l'
  else ' '
  end
end

def octal_to_rwx(mode)
  octal_str = format('%03o', mode & 0o777)
  perm_map = {
    '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
    '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
  }
  
  octal_str.chars.map { |char| perm_map[char] }.join
end

def build_details(files)
  files.map do |name|
    stat = File::Stat.new(name)
    {
      type: file_type(stat),
      permission: octal_to_rwx(stat.mode),
      link: stat.nlink,
      owner: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size,
      mtime: stat.mtime.strftime('%b %e %H:%M'),
      name: name
    }
  end
end

def max_width(data, key)
  data.map { |d| d[key].to_s.length }.max
end

def print_details(total, data)
  size_width = max_width(data, :size)
  link_width = max_width(data, :link)
  owner_width = max_width(data, :owner)
  group_width = max_width(data, :group)

  puts "total #{total}"
  data.each do |d|
    line = [
      "#{d[:type]}#{d[:permission]}",
      d[:link].to_s.rjust(link_width),
      d[:owner].to_s.ljust(owner_width),
      d[:group].to_s.ljust(group_width),
      d[:size].to_s.rjust(size_width),
      d[:mtime],
      d[:name]
    ].join(' ')
    puts line
  end
end

def calculate_rows(file_count, cols)
  file_count.ceildiv(cols)
end

def build_grid(files, rows)
  return [] if files.empty?

  files.each_slice(rows).map { |col| col.fill(nil, col.length...rows) }.transpose
end

def print_grid(grid, column_width)
  grid.each do |row|
    puts row.compact.map { |cell| cell.ljust(column_width) }.join
  end
end

opt = ARGV.getopts('a', 'r','l')
files = fetch_files(opt)

if opt['l']
  total = files.sum { |name| File::Stat.new(name).blocks } / 2
  data = build_details(files)
  print_details(total, data)
else
  rows = calculate_rows(files.size, COLS)
  grid = build_grid(files, rows)
  max_length = files.map(&:length).max || 0
  column_width = max_length + 2
  print_grid(grid, column_width)
end
