def calculate_bonus(pay, bonus)
  bonus ? (pay / 2) : 0
end


puts calculate_bonus(2800, true) == 1400
puts calculate_bonus(1000, false) == 0
puts calculate_bonus(50000, true) == 25000

#algo

# - if second argument is true, divide the income by 2. If not, should be 0