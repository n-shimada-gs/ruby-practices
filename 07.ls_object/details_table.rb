# frozen_string_literal: true

require_relative './detail'

class DetailsTable
  def initialize(files)
    @details = files.map { |file| Detail.new(file) }
  end

  def print
    widths = %i[size link owner group].to_h { |key| [key, max_width(key)] }
    total = @details.sum(&:blocks) / 2

    puts "total #{total}"
    @details.each do |d|
      line = [
        "#{d.type}#{d.permission}",
        d.link.to_s.rjust(widths[:link]),
        d.owner.to_s.ljust(widths[:owner]),
        d.group.to_s.ljust(widths[:group]),
        d.size.to_s.rjust(widths[:size]),
        d.mtime.strftime('%b %e %H:%M'),
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
