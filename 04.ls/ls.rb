#!/usr/bin/env ruby
# frozen_string_literal: true

def fetch_files(target_dir = '.')
  Dir.glob('*', base: target_dir).sort
end

def calculate_rows(file_count, cols)
  (file_count / cols.to_f).ceil
end

def build_grid(files, rows)
  return [] if files.empty?

  files.each_slice(rows).map { |col| col.fill(nil, col.length...rows) }.transpose
end

def print_grid(grid, column_width)
  grid.each do |row|
    puts row.compact.map { |cell| cell.ljust(column_width) }.join('')
  end
end

cols = 3
files = fetch_files
rows = calculate_rows(files.size, cols)
grid = build_grid(files, rows)
max_length = files.map(&:length).max || 0
column_width = max_length + 2

print_grid(grid, column_width)
