def sum_square_difference(integer)
  num_arr = [*(1..integer)]
  sum_squared = (num_arr.sum)**2

  num_arr.each { |num| squared_sum += num**2}

  sum_squared - squared_sum
end


p sum_square_difference(3) == 22
   # -> (1 + 2 + 3)**2 - (1**2 + 2**2 + 3**2)
p sum_square_difference(10) == 2640
p sum_square_difference(1) == 0
p sum_square_difference(100) == 25164150


# input = integer
# output = integer

# set an variable to 1 up to argument
# set sum_squared
# - (numbers.sum)**2
# set squared_sum
# - numbers.each { |num| squared_sum += num**2 }
# sum_squared - squared_sum