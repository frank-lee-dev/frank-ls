require "pry"

def century(input)
  counter = 0

  loop do
    counter += 1
    break if (counter * 100) >= input
  end

  century_num = counter.to_s
  if century_num.end_with?("10", "11", "12", "13")
    century_num + "th"
  elsif century_num.end_with?("1")
    century_num + "st"
  elsif century_num.end_with?("2")
    century_num + "nd"
  elsif century_num.end_with?("3")
    century_num + "rd"
  else
    century_num + "th"
  end
end

p century(2000) == '20th'
p century(2001) == '21st'
p century(1965) == '20th'
p century(256) == '3rd'
p century(5) == '1st'
p century(10103) == '102nd'
p century(1052) == '11th'
p century(1127) == '12th'
p century(11201) == '113th'


# algo
# - Start with a counter at 0
# - Run a calculation loop
#   - add 1 to the counter
#   - validate if the counter is greater than or equal to the counter * 100
#     - break if it's true
# - Set century value as counter value in string

# - Method to apend the string
# - If the counter ends with 10 and 13, add 'th' to the end
# - If the last character ends with 1, add 'st' to the end (end_with?, + operator)
# - If the last character ends with 2, add 'nd' to the end
# - If the last character ends with 3, add 'rd' to the end
# - If anything else, add 'th' to the end