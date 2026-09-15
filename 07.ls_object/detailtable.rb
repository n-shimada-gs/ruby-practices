# frozen_string_literal: true

require_relative './detail'

class DetailsTable
  def initialize(files)
    stats = files.map { |name| File::Stat.new(name) }
    @details = files.zip(stats).map { |name, stat| Detail.new(name, stat).build }
    @total = stats.sum(&:blocks) / 2
  end

  def print
    size_width = max_width(:size)
    link_width = max_width(:link)
    owner_width = max_width(:owner)
    group_width = max_width(:group)

    puts "total #{@total}"
    @details.each do |d|
      line = [
        "#{d[:type]}#{d[:permission]}",
        d[:link].to_s.rjust(link_width),
        d[:owner].to_s.ljust(owner_width),
        d[:group].to_s.ljust(group_width),
        d[:size].to_s.rjust(size_width),
        d[:mtime],
        d[:name]
      ].join(' ')
      puts line
    end
  end

  private

  def max_width(key)
    @details.map { |d| d[key].to_s.length }.max
  end
end
