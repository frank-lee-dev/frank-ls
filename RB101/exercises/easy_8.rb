def center_of(string)
  letter_count = string.size / 2
  half_count = letter_count / 2
  letter_count.odd? ? string[half_count] : string[(half_count - 1)..half_count]
end

p center_of('I love ruby') == 'e'
p center_of('Launch School') == ' '
p center_of('Launch') == 'un'
p center_of('Launchschool') == 'hs'
p center_of('x') == 'x'