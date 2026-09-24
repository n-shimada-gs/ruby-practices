# frozen_string_literal: true

require 'optparse'
require_relative './details_table'
require_relative './grid'

def fetch_files(opt, target_dir = '.')
  flags = opt['a'] ? File::FNM_DOTMATCH : 0
  files_list = Dir.glob('*', base: target_dir, flags: flags)
  opt['r'] ? files_list.reverse : files_list
end

opt = ARGV.getopts('a', 'r', 'l')
files = fetch_files(opt)

view = opt['l'] ? DetailsTable.new(files) : Grid.new(files)
view.print
