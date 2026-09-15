# frozen_string_literal: true

class List
  def initialize(opt, target_dir = '.')
    @opt = opt
    @target_dir = target_dir
  end

  def fetch_files
    flags = @opt['a'] ? File::FNM_DOTMATCH : 0
    files_list = Dir.glob('*', base: @target_dir, flags: flags)
    @opt['r'] ? files_list.reverse : files_list
  end
end
