# frozen_string_literal: true

require 'etc'

class Detail
  PERMISSION_TABLE = {
    '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
    '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
  }.freeze

  FILE_TYPE_CHARS = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'socket' => 's'
  }.freeze

  attr_reader :name

  def initialize(name, stat)
    @name = name
    @stat = stat
  end

  def type
    FILE_TYPE_CHARS[@stat.ftype] || ' '
  end

  def permission
    octal_str = format('%03o', @stat.mode & 0o777)
    perm = octal_str.chars.map { |char| PERMISSION_TABLE[char] }.join
    perm[2] = special_bit_char(perm[2], @stat.setuid?, 's', 'S')
    perm[5] = special_bit_char(perm[5], @stat.setgid?, 's', 'S')
    perm[8] = special_bit_char(perm[8], @stat.sticky?, 't', 'T')
    perm
  end

  def link
    @stat.nlink
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime.strftime('%b %e %H:%M')
  end

  def blocks
    @stat.blocks
  end

  private

  def special_bit_char(current_char, bit_set, exec_char, no_exec_char)
    return current_char unless bit_set

    current_char == 'x' ? exec_char : no_exec_char
  end
end
