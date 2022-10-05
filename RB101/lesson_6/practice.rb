def joinor(arr, punc = ', ', conj = 'or')
  case arr.size
  when 0 then ''
  when 1 then "#{arr.first}"
  when 2 then arr.join(" #{conj} ")
  else
    arr[-1] = "#{conj} #{arr.last}"
    arr.join("#{punc}")
  end
end

p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"


# algo
# - method should have 1 required argument and 2 default arugments set
#   - first is the array (required)
#   - second is comma by default
#   - third is or by default
# - the array should be joined by the second argument given
#   - join(second_arguent)
# - third argument should be inserted in the second to last spot of the 
#   - insert(-1, third operator)