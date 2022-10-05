VALUES = {
  0 => '0', 1 => '1', 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6',
  7 => '7', 8 => '8', 9 => '9'
}

def integer_to_string(input)
  arr = []
  temp_value = input
  counter = 10**((input.digits.count) - 1)

  loop do
    arr << (temp_value / counter)
    temp_value %= counter
    counter /= 10
    break if counter < 1
  end

  arr.map!{ |num| VALUES[num] }.join
end

def signed_integer_to_string(number)
  return '0' if number == 0
  output = integer_to_string(number.abs)
  number < 0 ? output.prepend('-') : output.prepend('+')
end

p signed_integer_to_string(4321) == '+4321'
p signed_integer_to_string(-123) == '-123'
p signed_integer_to_string(0) == '0'


# Algo
# - If 0, it should return 0
# - If digit is greater than 0, set sign to be positive
# - If digit is lower than 0, set sign to be negative
#   - multiply the number by negative 1
# - Run the integer to string method
# - prepend the string with a positive sign if positive or negative sign if negative.

# Write a method that takes a positive integer or zero, and converts it to a string representation.



# 4321 % (10**digit length) = 4
#   digit_length = digit.length.count
# 4321 / 1000 = 4
# 4321 % 1000 = 321
# 321 / 100 = 3
# 321 % 100 = 21


# Algo
# set a constant that has integers as keys and string version as values
# set empty array
# set temp_value to argument
# set counter to 0
# start a loop
  # set counter to 10 ** digit length
  #   - define digit length by separating the digits as individual numbers and  
  #    then counting that
  # get argument divided by counter and store to array
  # set temp_value to argument modulo counter
  # set counter to counter / 10
# run the loop again until counter < 1
# iterate on each value in the array by using the constant (mutation)
# join the values in the array