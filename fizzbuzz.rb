x = (1..20).to_a 

x.each do |x|
    case x 
    when 3, 6, 9, 12, 18
        puts "Fizz" 
    when 5, 10, 20
        puts "Buzz"
    when 15
        puts "FizzBuzz"
    else puts x.to_s
    end
end
