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
    print_grid(build_grid, column_width)
  end

  private

  def calculate_rows
    @files.size.ceildiv(COLS)
  end

  def build_grid
    rows = calculate_rows
    @files.each_slice(rows).map { |col| col.fill(nil, col.length...rows) }.transpose
  end

  def print_grid(grid, column_width)
    grid.each do |row|
      puts row.compact.map { |cell| cell.ljust(column_width) }.join
    end
  end
end
