arr = []

puts '==> Enter the 1st number:'
arr << gets.chomp.to_i

puts '==> Enter the 2nd number:'
arr << gets.chomp.to_i

puts '==> Enter the 3rd number:'
arr << gets.chomp.to_i

puts '==> Enter the 4th number:'
arr << gets.chomp.to_i

puts '==> Enter the 5th number:'
arr << gets.chomp.to_i

puts '==> Enter the last number:'
last_number = gets.chomp.to_i

if arr.any?(last_number)
  puts "The number #{last_number} appears in #{arr}"
else
  puts "The number #{last_number} does not appear in #{arr}"
end