# frozen_string_literal: true

class RawData
  def initialize(raw)
    @raw = raw
  end

  def file_type?
    case @raw.ftype
    when 'file' then '-'
    when 'directory' then 'd'
    when 'link' then 'l'
    when 'characterSpecial' then 'c'
    when 'blockSpecial' then 'b'
    when 'fifo' then 'p'
    when 'socket' then 's'
    else ' '
    end
  end

  def permission?
    mode = @raw.mode
    octal_str = format('%03o', mode & 0o777)
    perm_map = {
      '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
      '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
    }
    perm = octal_str.chars.map { |char| perm_map[char] }.join
    perm[2] = special_bit_char(perm[2], @raw.setuid?, 's', 'S')
    perm[5] = special_bit_char(perm[5], @raw.setgid?, 's', 'S')
    perm[8] = special_bit_char(perm[8], @raw.sticky?, 't', 'T')
    perm
  end

  private

  def special_bit_char(current_char, bit_set, exec_char, no_exec_char)
    return current_char unless bit_set

    current_char == 'x' ? exec_char : no_exec_char
  end
end
