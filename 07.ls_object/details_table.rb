# frozen_string_literal: true

require_relative './detail'

class DetailsTable
  def initialize(files)
    @details = files.map { |name| Detail.new(name, File::Stat.new(name)) }
  end

  def print
    width = %i[size link owner group].to_h { |key| [key, max_width(key)] }
    total = @details.sum(&:blocks) / 2

    puts "total #{total}"
    @details.each do |d|
      line = [
        "#{d.type}#{d.permission}",
        d.link.to_s.rjust(width[:link]),
        d.owner.to_s.ljust(width[:owner]),
        d.group.to_s.ljust(width[:group]),
        d.size.to_s.rjust(width[:size]),
        d.mtime,
        d.name
      ].join(' ')
      puts line
    end
  end

  private

  def max_width(key)
    @details.map { |d| d.public_send(key).to_s.length }.max
  end
end
