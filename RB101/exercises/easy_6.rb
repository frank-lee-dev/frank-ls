# Initial answer
def triangle(int)
  counter = 0

  loop do
    puts (" " * (int - counter)) + ("*" * counter)
    counter += 1
    break if counter > int
  end
end

# Further exploration
def triangle(int)
  counter = int

  loop do
    puts ("*" * counter) + (" " * (int - counter))
    counter -= 1
    break if counter < 0
  end
end

def triangle(int)
  counter = int

  loop do
    puts (" " * (int - counter)) + ("*" * counter)
    counter -= 1
    break if counter < 0
  end
end

def triangle(int)
  counter = 0

  loop do
    puts ("*" * counter) + (" " * (int - counter))
    counter += 1
    break if counter > int
  end
end

triangle(9)


# input = integer
# output = puts

# algo
# 
# - set counter = 1
# - start a loop
#  - puts space * (argument - counter) + star * counter
#  - add 1 to the counter
#  - break if counter = argument
