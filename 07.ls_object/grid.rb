# frozen_string_literal: true

require 'optparse'

class Grid
  COLS = 3

  def initialize(files)
    @files = files
  end

  def print
    return if @files.empty?

    column_width = @files.map(&:length).max + 2
    print_grid(column_width)
  end

  private

  def build_grid
    rows = @files.size.ceildiv(COLS)
    @files.each_slice(rows).map do |col|
      col.fill(nil, col.length...rows)
    end.transpose
  end

  def print_grid(column_width)
    build_grid.each do |row|
      line = row.compact.map do |cell|
        cell.ljust(column_width)
      end.join
      puts line
    end
  end
end
