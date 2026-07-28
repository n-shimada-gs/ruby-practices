x = (1..20).to_a 

x.each do |x|
  case
  when x % 15 == 0
    puts "Fizz" 
  when x % 3 == 0
    puts "Buzz"
  when x % 5 == 0
    puts "FizzBuzz"
  else puts x.to_s
  end
end
