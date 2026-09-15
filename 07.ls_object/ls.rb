# frozen_string_literal: true

require 'optparse'
require_relative './list'
require_relative './detailtable'
require_relative './grid'

opt = ARGV.getopts('a', 'r', 'l')
files = List.new(opt).fetch_files

if opt['l']
  DetailsTable.new(files).print
else
  Grid.new(files).print
end
