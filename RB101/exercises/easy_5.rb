def print_in_box(string)
  length = string.size

  puts "+-#{"-" * length}-+"
  puts "| #{" " * length} |"
  puts "| #{string} |"
  puts "| #{" " * length} |"
  puts "+-#{"-" * length}-+"
end

print_in_box('To boldly go where no one has gone before.')


# algo
# - declare a variable that measures the length of the argument
# - for top and bottom, insert hyphen times the length variable
# - for lines 2 and 4, insert space times the length variable
# - for line 3, insert the argument