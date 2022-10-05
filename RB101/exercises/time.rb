MINUTES_IN_HOUR = 60
MINUTES_IN_DAY = 1440

def time_to_minutes(string)
  hour = string[..1].to_i
  minute = string[3..].to_i
  (hour * MINUTES_IN_HOUR) + minute
end

def after_midnight(string)
  return 0 if time_to_minutes(string) == MINUTES_IN_DAY
  time_to_minutes(string)
end

def before_midnight(string)
  return 0 if time_to_minutes(string) == 0
  MINUTES_IN_DAY - time_to_minutes(string)
end

p after_midnight('00:00') == 0
p before_midnight('00:00') == 0
p after_midnight('12:34') == 754
p before_midnight('12:34') == 686
p after_midnight('24:00') == 0
p before_midnight('24:00') == 0


# input = string
# output = integer

# Algorithm

# - Define a method that gets total minutes for the string given
#   - Get first 2 characters, convert to integer, set to hour
#   - Get the ast 2 characters, convert to integer, set to minutes
#   - Do (hour * 60) + minutes

# - Define a method for after midnight
#   - Run string to integer method

# - Define a method for before midnight
#   - Run string to integer method
#   - Do 1440 - (total minutes)