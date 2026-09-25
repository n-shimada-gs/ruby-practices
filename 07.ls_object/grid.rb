# frozen_string_literal: true

require 'optparse'

class Grid
  COLS = 3

  def initialize(files)
    @files = files
  end

  def print
    return if @files.empty?

    width = @files.map(&:length).max + 2
    print_grid(width)
  end

  private

  def print_grid(width)
    build_grid.each do |row|
      line = row.compact.map do |cell|
        cell.ljust(width)
      end.join
      puts line
    end
  end

  def build_grid
    rows = @files.size.ceildiv(COLS)
    @files.each_slice(rows).map do |col|
      col.fill(nil, col.length...rows)
    end.transpose
  end
end
