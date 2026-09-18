# frozen_string_literal: true

require 'optparse'

def count_file(file)
  content = file.nil? ? $stdin.read : File.read(file)
  {
    lines: content.count("\n"),
    words: content.split.size,
    bytes: content.bytesize,
    path: file
  }
end

def calculate_total(results)
  {
    lines: results.sum { |result| result[:lines] },
    words: results.sum { |result| result[:words] },
    bytes: results.sum { |result| result[:bytes] },
    path: 'total'
  }
end

def select_options(opt)
  options = []
  options << :lines if opt['l']
  options << :words if opt['w']
  options << :bytes if opt['c']
  options.empty? ? %i[lines words bytes] : options
end

def calculate_width(results, options)
  values_per_file = results.map do |result|
    options.map { |opt| result[opt] }
  end
  all_values = values_per_file.flatten
  all_values.max.to_s.size
end

def print_files(result, options, width)
  number_strings = options.map do |opt|
    result[opt].to_s.rjust(width)
  end
  parts = number_strings
  parts << result[:path] if result[:path]
  parts.join(' ')
end

opt = ARGV.getopts('l', 'w', 'c')
input = ARGV
options = select_options(opt)

files = input.empty? ? [nil] : input
results = files.map { |file| count_file(file) }

if input.empty?
  width = options.size == 1 ? 1 : 7
else
  results << calculate_total(results) if results.size > 1
  width = calculate_width(results, options)
end

results.each do |result|
  puts print_files(result, options, width)
end
