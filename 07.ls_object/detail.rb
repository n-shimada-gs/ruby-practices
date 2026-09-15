# frozen_string_literal: true

require 'etc'
require_relative './raw'

class Detail
  def initialize(name, stat)
    @name = name
    @stat = stat
    @raw = RawData.new(stat)
  end

  def build
    {
      type: @raw.file_type?,
      permission: @raw.permission?,
      link: @stat.nlink,
      owner: Etc.getpwuid(@stat.uid).name,
      group: Etc.getgrgid(@stat.gid).name,
      size: @stat.size,
      mtime: @stat.mtime.strftime('%b %e %H:%M'),
      name: @name
    }
  end
end
