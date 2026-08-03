#!/usr/bin/env ruby

numbers = (1..20) 

numbers.each do |x|
  case
  when x % 15 == 0
    puts "FizzBuzz"
  when x % 3 == 0
    puts "Fizz"
  when x % 5 == 0
    puts "Buzz"
  else
    puts x
  end
end

