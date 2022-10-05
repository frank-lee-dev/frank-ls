def multiply(number_set, multiply_by)
  multiplied_numbers = []
  counter = 0

  loop do
    break if counter == number_set.size
    
    current_number = number_set[counter]
    multiplied_number = current_number * multiply_by
    multiplied_numbers << multiplied_number

    counter += 1
  end

  multiplied_numbers
end



my_numbers = [1, 4, 3, 7, 2, 6]
p multiply(my_numbers, 5) # => [3, 12, 9, 21, 6, 18]

# Continuing on with the idea of building generic methods, let's update our double_numbers method to not only be able to double the values in an array, but to multiply by any number. For example, let's create a method called multiply that can take an additional argument to determine the transformation criteria.

# Algo
# transformation loop
# multiply each number by 3