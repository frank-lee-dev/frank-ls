

def toggle_lights(n)
lights = {}
(1..n).each { |num| lights.store(num, false)}
current_num = 0
multiplier = 1

loop do
  current_num += 1
  loop do
    result = current_num * multiplier
    break if result > n
    lights[result] = !lights[result]
    multiplier += 1
  end
  break if current_num >  n
  multiplier = 1
end

on_lights = lights.select { |k,v| v == true}.keys
off_lights = lights.select { |k,v| v == false}.keys

puts "lights #{off_lights.join(", ")} are now off; #{on_lights.join(", ")} are now on."

end

toggle_lights(40)

# input = integer
# output = array

# all lights are off initially
# start from multiplier at 1 and multiply that by 1..n
# anytime a number is stopped on, it should change the boolean value
# once you reach the end, start over again and add 1 to the multiplier

# create a new hash with 1..n as values and default at false
#   e.g. { 1 => false, 2 => false, 3 => false ..}
# set current_num to 0
# set multiplier to 1
# start a loop
# - add 1 to current_num
# - start another loop
#  - multiply current_num by multiplier and save as result
#  - break if result > hash.length
#  - flip the boolean value of that result key
#  - add 1 to the multiplier
# - break if current_num > hash.length
# return hash keys that have true value